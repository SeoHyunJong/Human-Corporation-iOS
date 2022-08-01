//
//  NoMoreAddDiary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/27.
//

import SwiftUI

struct NoMoreAddDiary: View {
    var body: some View {
        VStack(spacing: 25) {
            Label("더 이상 추가할 일과가 없네요.", systemImage: "clock.badge.checkmark")
            Text("최근 일과까지 다 추가하셨나 보군요?")
            Text("대단해요!")
        }
    }
}

struct NoMoreAddDiary_Previews: PreviewProvider {
    static var previews: some View {
        NoMoreAddDiary()
    }
}
