//
//  NewCommerView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct NewCommerView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var message: [String] =
    ["환영한다, 인간! 난 외계행성에서 온 외계투자자 마몽이라고 한다! 이 앱을 개발했지!",
     "왜 외계인이 자기개발 앱을 만든거야?",
     "이건 평범한 앱이 아니다! 우리 외계인이 너희 지구인들의 가치를 판단하기 위함이다.",
     "우리의 가치를 판단한다고? 우리에게 가격표라도 있는거야?",
     "그렇다! 이 앱은 너희 지구인들의 루틴을 평가해서 가격으로 환산한다!",
     "예를 들면 어떻게...??",
     "너희 지구인들이 하루 일과에 대해 일기를 쓰면 된다. 시간대 별로 작성할 수 있지!",
     "음 그럼 시간별로 자신이 한 일을 작성하면 그걸 돈으로 환산하는거네?",
     "그렇다! 이해도가 빠르군.",
     "그럼 우리가 한 일은 어떻게 평가해? 무슨 기준으로?",
     "크흠... 그건 지구인들 개개인의 양심에 따라...큼",
     "뭐야! 분식회계도 가능하다는거잖아!",
     "어,어디까지나 지구인들을 위한 자기개발 앱이니 객관적으로 판단할거라 믿는다!",
     "근데 너희 외계인들이 우리 지구인들의 가치를 판단하는 이유가 뭐야? 주식도 아니고...",
     "후후후... 너희 인간들이 죽으면... 사후세계에서 너희의 영혼들은...! 흐흐흐",
     "(불길하다! 가만 보니 외계인치고는 마귀처럼 생겼잖아! 빨리 앱을 삭제하고 다른 앱을...)",
     "농,농담이다! 장난삼아 한 말이다.",
     "어쨌든 난 이 앱으로 시간별로 일기를 작성하면 되는거지?",
     "그렇다! 이제 너 지구인의 정보를 입력하라!"
    ]
    @State private var step: Int = 0
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(0...step, id: \.self) { idx in
                        MessageBox(message: message[idx], leftSpeaker: idx % 2 == 0 ? true:false)
                    }
                    .onChange(of: step) { _ in
                        value.scrollTo(step)
                    }
                }
            }
            Button {
                if step < message.count - 1 {
                    step += 1
                } else {
                    viewModel.infoNext = true
                }
            } label: {
                Label("next", systemImage: "arrow.right.circle.fill")
            }
            .padding()
        }
    }
}

struct NewCommerView_Previews: PreviewProvider {
    static var previews: some View {
        NewCommerView()
            .environmentObject(ViewModel())
    }
}
