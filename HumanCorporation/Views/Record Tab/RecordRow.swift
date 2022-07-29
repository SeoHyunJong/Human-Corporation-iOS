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
    @State var icon: String = "moon.zzz"
    
    var body: some View {
        List {
            ForEach(items, id: \.self.startTime) { diary in

                    VStack(alignment: .leading){
                        Label("\(dateFormatter.string(from: diary.startTime))  ~  \(dateFormatter.string(from: diary.endTime))", systemImage: switchIcon(eval: diary.eval))
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
}

struct RecordRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(dateName: "2022.07.29.Fri", items: [
            Diary(story: "테스트", startTime: Calendar.current.date(byAdding: .minute, value: -10, to: Date())!, endTime: Date(), eval: .productive),
            Diary(story: "1234567890!@#$%^&*()abcdefghijklmnopqrstuvwx", startTime: Date(), endTime: Date(), eval: .unproductive)]
        )
    }
}
