//
//  NewCommerView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct NewCommerView: View {
    @State private var message: [String] =
    ["반갑다, 인간! 난 마그마그마 행성에서 온 외계투자자 마몽이라고 한다!",
     "외, 외계투자자?!",
     "그렇다! 우리 외계투자자들은 먼 우주에서 너희 지구인들을 투자하고 있지.",
     "지구인들을 투자한다니? 우리에게 가격표라도 있는거야?",
     "그렇다! 이 앱을 통해 너희 지구인들의 현재 가치를 평가하고 있다!",
     "근데 너희가 우릴 투자해서 얻는게 뭐야?",
     "후후후... 너희 지구인들이 죽으면 너희의 영혼들은 사후세계에서... 흐흐흐!",
     "(불길하다. 빨리 이 앱을 삭제하고 다른 자기개발 앱을 찾아봐야지)",
     "잠, 잠깐! 방금한 말은 농담이다, 농담!",
     "빨리 사용법이나 알려줘"
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
    }
}
