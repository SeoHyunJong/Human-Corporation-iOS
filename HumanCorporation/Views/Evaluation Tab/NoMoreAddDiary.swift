//
//  NoMoreAddDiary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/27.
//

import SwiftUI

struct NoMoreAddDiary: View {
    var body: some View {
        MessageBox(message: "최근 날짜까지 실적을 추가했나보군! 대단히 성실하다. 놀랍다!", leftSpeaker: true)
    }
}

struct NoMoreAddDiary_Previews: PreviewProvider {
    static var previews: some View {
        NoMoreAddDiary()
    }
}
