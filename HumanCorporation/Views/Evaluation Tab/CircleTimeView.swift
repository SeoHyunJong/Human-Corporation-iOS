//
//  CircleTimeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/04.
//
import SwiftUI
import AlertToast

struct CircleTimeView: View {
    var diaryList: [Diary]
    @State private var amount = 0
    @State private var showTime = false
    @State private var viewDiary: Diary = Diary(story: "", startTime: Date(), endTime: Date())
    @State private var dateFormatter = DateFormatter()
    
    var body: some View {
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
                    ForEach(diaryList, id: \.self) { diary in
                        let from = diary.startTime.timeIntervalSince(Calendar.current.startOfDay(for: diary.startTime)) / (3600*24)
                        let to = diary.endTime.timeIntervalSince(Calendar.current.startOfDay(for: diary.startTime)) / (3600*24)
                        let color = { () -> Color in
                            if diary.eval == .productive {
                                return Color.red
                            } else if diary.eval == .unproductive {
                                return Color.blue
                            } else {
                                return Color.green
                            }
                        }
                        CircleTabView(from: from, to: to, color: color(), diary: diary, showTime: $showTime, viewDiary: $viewDiary)
                    }
                }
                Text("12")
                    .foregroundColor(.secondary)
            }
            Text("6")
                .foregroundColor(.secondary)
        }
        .onAppear(){
            dateFormatter.dateFormat = "hh시 mm분 a"
        }
        .fixedSize(horizontal: true, vertical: true)
        .toast(isPresenting: $showTime) {
            AlertToast(displayMode: .alert, type: .regular, title: dateFormatter.string(from: viewDiary.startTime) + "\n" +
                       dateFormatter.string(from: viewDiary.endTime))
        }
    }
}

struct CircleTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTimeView(diaryList: [])
    }
}
