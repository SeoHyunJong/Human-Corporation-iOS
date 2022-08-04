//
//  CircleTimeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/04.
//
import SwiftUI
import AlertToast

struct CircleTimeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var amount = 0
    @State private var amountOfProductive: Double = 0
    @State private var amountOfUnproductive: Double = 0
    @State private var amountOfNeutral: Double = 0
    
    var body: some View {
        HStack(spacing: 30){
            HStack {
                Text("18")
                    .foregroundColor(.secondary)
                VStack(spacing: 5) {
                    Text("24")
                        .foregroundColor(.secondary)
                    ZStack {
                        Circle()
                            .stroke()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(-90))
                        ForEach(viewModel.tempDiaryList, id: \.self) { diary in
                            let from = diary.startTime.timeIntervalSince(Calendar.current.startOfDay(for: diary.startTime)) / (3600*24)
                            let to = diary.endTime.timeIntervalSince(Calendar.current.startOfDay(for: diary.startTime)) / (3600*24)
                            let amount = (to - from) * 24
                            let color = { () -> Color in
                                if diary.eval == .productive {
                                    return Color.red
                                } else if diary.eval == .unproductive {
                                    return Color.blue
                                } else {
                                    return Color.green
                                }
                            }
                            CircleTabView(from: from, to: to, color: color(), diary: diary)
                                .onAppear(){
                                    switch diary.eval {
                                    case .productive:
                                        amountOfProductive += amount
                                    case .unproductive:
                                        amountOfUnproductive += amount
                                    case .neutral:
                                        amountOfNeutral += amount
                                    case .cancel:
                                        return
                                    }
                                }
                        }
                    }
                    Text("12")
                        .foregroundColor(.secondary)
                }
                Text("6")
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: true, vertical: true)
            
            VStack(alignment: .leading) {
                HStack {
                    Label("", systemImage: "plus.circle")
                    Text(String(format: "%.1f", amountOfProductive)+" h")
                }.foregroundColor(.red)
                HStack {
                    Label("", systemImage: "minus.circle")
                    Text(String(format: "%.1f", amountOfUnproductive)+" h")
                }.foregroundColor(.blue)
                HStack {
                    Label("", systemImage: "moon.zzz")
                    Text(String(format: "%.1f", amountOfNeutral)+" h")
                }.foregroundColor(.green)
            }
        }
        .onAppear(){
            amountOfProductive = 0
            amountOfUnproductive = 0
            amountOfNeutral = 0
        }
    }
}

struct CircleTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTimeView()
            .environmentObject(ViewModel())
    }
}
