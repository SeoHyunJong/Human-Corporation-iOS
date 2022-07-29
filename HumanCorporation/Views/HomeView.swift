//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
//HomeView -> Chart, Evaluation, Analysis, Discuss, Settings
import SwiftUI
// 시세   실적추가    종목분석    종목토론실
struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selection: Tab = .Chart
    @State private var showSetting = false
    
    enum Tab {
        case Chart
        case Evaluation
        case Analysis
        case Discussion
    }
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            VStack{
                VStack {
                    HStack{
                        Spacer()
                        Button {
                            showSetting.toggle()
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                                .labelStyle(.iconOnly)
                                .font(.system(size: width*0.04))
                        }
                        .padding(.horizontal)
                    }
                    HStack {
                        ProfileImage(image: viewModel.profileImage!)
                            .frame(width: width*0.3, height: width*0.3)
                        VStack(alignment: .leading) {
                            Text(viewModel.userProfile.name)
                                .font(.system(size: width*0.06))
                                .padding()
                            Text(viewModel.userProfile.goal)
                                .font(.system(size: width*0.04))
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .onAppear(){
                        if viewModel.state == .signedIn { //프리뷰 오류 때문에 추가...
                            //프로필 로드
                            viewModel.readUserFromDB()
                            viewModel.downloadImage()
                            //차트 데이터 로드
                            viewModel.priceRead(completion: { message in
                                print(message)
                            })
                            //임시 저장 데이터 로드
                            viewModel.readTempPriceList(completion: { message in
                                   print(message)
                            })
                            viewModel.readTempDiaryList(completion: { message in
                                print(message)
                         })
                        }
                    }
                }
                TabView(selection: $selection){
                    ChartView()
                        .tabItem{
                            Label("시세", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(Tab.Chart)
                    Group {
                        if viewModel.recentDay >= Date() {
                            NoMoreAddDiary()
                        } else {
                            EvaluationView()
                        }
                    }
                    .tabItem{
                        Label("실적추가", systemImage: "note.text.badge.plus")
                    }
                    .tag(Tab.Evaluation)
                    RecordView()
                        .tabItem{
                            Label("공시자료", systemImage: "scroll")
                        }
                        .tag(Tab.Analysis)
                    DiscussionView()
                        .tabItem{
                            Label("종목토론", systemImage: "quote.bubble.fill")
                        }
                        .tag(Tab.Discussion)
                }
                .padding(.bottom)
            }
            .sheet(isPresented: $showSetting){
                Setting()
                    .environmentObject(viewModel)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModel())
    }
}
