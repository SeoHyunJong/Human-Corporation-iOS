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
    var fetchCounter: Double
    var completeNumber: Double
    
    enum Tab {
        case Chart
        case Evaluation
        case Analysis
        case DataStatic
        case Discussion
    }
    var body: some View {
        VStack{
            TabView(selection: $selection){
                Group {
                    if fetchCounter >= completeNumber {
                        ChartView()
                    } else {
                        LoadingView(fetchCounter: fetchCounter, completeNumber: completeNumber)
                    }
                }
                .tabItem{
                    Label("시세", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.Chart)
                Group {
                    if fetchCounter >= completeNumber {
                        if viewModel.recentDay >= Date() {
                            NoMoreAddDiary()
                        } else {
                            EvaluationView()
                        }
                    } else {
                        LoadingView(fetchCounter: fetchCounter, completeNumber: completeNumber)
                    }
                }
                .tabItem{
                    Label("실적추가", systemImage: "note.text.badge.plus")
                }
                .tag(Tab.Evaluation)
                Group {
                    if fetchCounter >= completeNumber {
                        StatsView()
                    } else {
                        LoadingView(fetchCounter: fetchCounter, completeNumber: completeNumber)
                    }
                }
                .tabItem{
                    Label("통계", systemImage: "chart.bar.xaxis")
                }
                .tag(Tab.DataStatic)
                Group {
                    if fetchCounter >= completeNumber {
                        RecordView()
                    } else {
                        LoadingView(fetchCounter: fetchCounter, completeNumber: completeNumber)
                    }
                }
                .tabItem{
                    Label("전자공시", systemImage: "scroll")
                }
                .tag(Tab.Analysis)
                Group {
                    if fetchCounter >= completeNumber {
                        SocialView()
                    } else {
                        LoadingView(fetchCounter: fetchCounter, completeNumber: completeNumber)
                    }
                }
                .tabItem{
                    Label("종목비교", systemImage: "quote.bubble.fill")
                }
                .tag(Tab.Discussion)
            }
            .padding(.bottom)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(fetchCounter: 3, completeNumber: 5)
            .environmentObject(ViewModel())
    }
}
