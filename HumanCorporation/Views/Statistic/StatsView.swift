//
//  StatsView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/05.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var productiveCount: [Int:Int] = [0:3, 1:6, 2:6, 3:3, 4:2, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:1, 12:1, 13:0, 14:1, 15:8, 16:10, 17:10, 18:5, 19:7, 20:8, 21:8, 22:6, 23:4]
    @State private var unproductvieCount: [Int:Int] = [0:3, 1:6, 2:6, 3:3, 4:2, 5:0, 6:0, 7:0, 8:0, 9:0, 10:0, 11:1, 12:1, 13:0, 14:1, 15:8, 16:10, 17:10, 18:5, 19:7, 20:8, 21:8, 22:6, 23:4]
    @State private var maxCount = 0
    @State private var minCount = 0
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("가장 생산적인 시간")
                        .bold()
                        .font(.title2)
                    ForEach(productiveCount.sorted{ $0.value > $1.value }[0...4], id: \.key) { dict in
                        HStack{
                            Text("\(dict.key)h - \(dict.key+1)h")
                                .frame(width: 80)
                            ProgressView(value: Double(dict.value), total: Double(maxCount))
                                .progressViewStyle(.linear)
                                .tint(dict.value == maxCount ? .orange : .red )
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("가장 비생산적인 시간")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.secondary)
                    ForEach(unproductvieCount.sorted{ $0.value > $1.value }[0...4], id: \.key) { dict in
                        HStack{
                            Text("\(dict.key)h - \(dict.key+1)h")
                                .frame(width: 80)
                            ProgressView(value: Double(dict.value), total: Double(minCount))
                                .progressViewStyle(.linear)
                                .tint(dict.value == minCount ? .purple : .blue )
                        }
                    }
                }
                MessageBox(message: "통계는 표본이 많을수록 정확해진다! 만약 유저가 많아지면 평균가격도 올리겠다!", leftSpeaker: true)
            }
            .navigationTitle("Statistics")
            .listStyle(.plain)
            .toolbar {
                Button{
                    viewModel.diaryListFromFirebase.removeAll()
                    viewModel.readDiaryList(completion: { message in
                        print(message)
                        calcStatistics()
                    })
                } label: {
                    Label("새로고침", systemImage: "goforward")
                }
            }
            .onAppear() {
                calcStatistics()
            }
        }
        .navigationViewStyle(.stack)
    }
    func calcStatistics() {
        let productiveList = viewModel.diaryListFromFirebase.filter{ $0.eval == .productive }.map{ ($0.startTime.timeIntervalSince(Calendar.current.startOfDay(for: $0.startTime)), $0.endTime.timeIntervalSince(Calendar.current.startOfDay(for: $0.startTime))) }
        let unproductiveList = viewModel.diaryListFromFirebase.filter{ $0.eval == .unproductive }.map{ ($0.startTime.timeIntervalSince(Calendar.current.startOfDay(for: $0.startTime)), $0.endTime.timeIntervalSince(Calendar.current.startOfDay(for: $0.startTime))) }
        
        for clock in 0...23 {
            let start: Double = Double(clock * 3600)
            let end: Double = start + 3600
            let timeRange = start..<end
            let temp = productiveList.filter{ timeRange.overlaps($0..<$1) }
            let temp2 = unproductiveList.filter{ timeRange.overlaps($0..<$1) }
            productiveCount[clock] = temp.count
            unproductvieCount[clock] = temp2.count
        }
        maxCount = productiveCount.values.max()!
        minCount = unproductvieCount.values.max()!
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(ViewModel())
    }
}
