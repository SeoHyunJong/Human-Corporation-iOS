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
    @Binding var showTime: Bool
    @Binding var viewDiary: Diary
    
    var body: some View {
        Circle()
            .trim(from: from, to: to)
            .stroke(lineWidth: 20)
            .foregroundColor(color)
            .frame(width: 130, height: 130)
            .rotationEffect(.degrees(-90))
            .onTapGesture {
                viewDiary = diary
                showTime.toggle()
            }
    }
}
