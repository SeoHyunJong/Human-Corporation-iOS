//
//  RecordRow.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/29.
//

import SwiftUI

struct RecordRow: View {
    var dateName: String
    var items: [Diary]
    let dateFormatter = DateFormatter()
    @State private var icon: String = "moon.zzz"
    @State private var amountOfProductive: Double = 0
    @State private var amountOfUnproductive: Double = 0
    @State private var amountOfNeutral: Double = 0
    
    var body: some View {
        List {
            HStack(spacing: 30) {
                CircleTimeView(diaryList: items)
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
                .padding()
            }
            ForEach(items, id: \.self.startTime) { diary in
                VStack(alignment: .leading){
                    Label("\(dateFormatter.string(from: diary.startTime))  ~  \(dateFormatter.string(from: diary.endTime))", systemImage: switchIcon(eval: diary.eval))
                        .foregroundColor(switchColor(eval: diary.eval))
                        .padding(.vertical)
                    Text(diary.story)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(dateName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            dateFormatter.dateFormat = "MM/dd HH:mm"
            amountOfProductive = 0
            amountOfUnproductive = 0
            amountOfNeutral = 0
            for diary in items {
                let time = diary.endTime.timeIntervalSince(diary.startTime) / 60
                let amount = time / 60
                switch diary.eval {
                case .productive:
                    amountOfProductive += amount
                case .unproductive:
                    amountOfUnproductive += amount
                case .neutral:
                    amountOfNeutral += amount
                case .cancel:
                    break
                }
            }
        }
    }
    func switchIcon(eval: Diary.Evaluation) -> String {
        switch eval {
        case .productive:
            return "plus.circle"
        case .unproductive:
            return "minus.circle"
        case .neutral:
            return "moon.zzz"
        case .cancel:
            return ""
        }
    }
    func switchColor(eval: Diary.Evaluation) -> Color {
        switch eval {
        case .productive:
            return .red
        case .unproductive:
            return .blue
        case .neutral:
            return .green
        case .cancel:
            return .black
        }
    }
}

struct RecordRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(dateName: "2022.07.29.Fri", items: [
            Diary(story: "테스트", startTime: Calendar.current.date(byAdding: .minute, value: -60, to: Date())!, endTime: Date(), eval: .productive),
            Diary(story: "1234567890!@#$%^&*()abcdefghijklmnopqrstuvwx", startTime: Date(), endTime: Calendar.current.date(byAdding: .minute, value: 60, to: Date())!, eval: .unproductive)]
        )
    }
}
