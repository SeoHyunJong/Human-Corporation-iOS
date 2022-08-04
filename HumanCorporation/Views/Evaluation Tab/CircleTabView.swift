//
//  CircleTabView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/04.
//

import SwiftUI
import AlertToast

struct CircleTabView: View {
    var from: Double
    var to: Double
    var color: Color
    var diary: Diary
    @State private var dateFormatter = DateFormatter()
    @State private var showTime = false
    
    var body: some View {
        Circle()
            .trim(from: from, to: to)
            .stroke(lineWidth: 20)
            .foregroundColor(color)
            .frame(width: 130, height: 130)
            .rotationEffect(.degrees(-90))
            .onAppear(){
                dateFormatter.dateFormat = "hh시 mm분 a"
            }
            .onTapGesture {
                showTime.toggle()
            }
            .toast(isPresenting: $showTime) {
                AlertToast(displayMode: .alert, type: .regular, title: dateFormatter.string(from: diary.startTime) + "\n" +
                           dateFormatter.string(from: diary.endTime))
            }
    }
}
