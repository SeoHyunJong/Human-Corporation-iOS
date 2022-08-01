//
//  ImageDescriptionView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct ImageDescriptionView: View {
    @State private var imgName : String = "eval_one"
    private var message: [String] = [
    "실적추가 탭을 클릭하면 다음과 같은 화면이 나온다. 캘린더 버튼으로 날짜를 선택할 수 있다.",
    "그 다음 일과를 시작한 시작 시간을 선택하고 종료 시간을 선택한다.",
    "그러면 이렇게 미니 일기 작성 버튼이 활성화된다!",
    "일기에는 그 시간대에 무슨 짓을 했는지 상세하게 적어야 한다.",
    "그 시간에 한 일이 생산적인지 비생산적인지에 따라 버튼을 눌러주면 된다!",
    "이렇게 모든 일과의 일기들을 작성하면 밑에 있는 완성하기 버튼을 누르면 된다!",
    "시세 탭에서는 너의 현재 인생 가격 추이를 볼 수 있고",
    "전자공시 탭에서는 이전에 썼던 일기들을 볼 수 있다!"
    ]
    var body: some View {
        VStack {
            ZStack {
                Image(imgName)
                    .resizable()
                    .scaledToFit()
                MessageBox(message: message[0], leftSpeaker: true)
            }
            Button {
                
            } label: {
                Label("next", systemImage: "arrow.right.circle.fill")
            }
            .padding()
        }
    }
}

struct ImageDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDescriptionView()
    }
}
