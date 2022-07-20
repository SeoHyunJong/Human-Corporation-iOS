//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//

import SwiftUI
// 시세   실적추가    종목분석    종목토론실
struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selection: Tab = .Chart
    @State private var image = UIImage(named: "Mamong")!
    @State private var showSheet = false
    
    enum Tab {
        case Chart
        case Evaluation
        case Analysis
        case Discussion
    }
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    viewModel.signOut()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                        .labelStyle(.iconOnly)
                }.padding()
            }
            HStack {
                ProfileImage(image: $image)
                VStack {
                    Text("Seo Hyun Jong")
                        .font(.title)
                    Divider()
                    Text("My Goal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }.padding(.horizontal)
            TabView(selection: $selection){
                ChartView()
                    .tabItem{
                        Label("시세", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(Tab.Chart)
                EvaluationView()
                    .tabItem{
                        Label("실적추가", systemImage: "note.text.badge.plus")
                    }
                    .tag(Tab.Evaluation)
                AnalysisView()
                    .tabItem{
                        Label("종목분석", systemImage: "scroll")
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
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModel())
    }
}
