//
//  NewCommerView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct NewCommerView: View {
    @State var message: [String] =
    ["반갑다, 인간! 난 마그마그마 행성에서 온 외계투자자 마몽이라고 한다!",
     "외계투자자...??",
     "그렇다! 우리 외계투자자들은 이 앱을 통해 너희 지구인들을 투자하고 있지.",
     "그럼 우리가 외계인들한테 주식과 같은건가??",
     "그렇다!",
     "근데 너희가 우릴 투자해서 얻는게 뭐야?",
     "후후후... 너희 지구인들이 죽으면 너희의 영혼들은 사후세계에서... 흐흐흐!",
     "(불길하다. 빨리 이 앱을 삭제하고 다른 자기개발 앱을 찾아봐야지)",
     "잠, 잠깐! 방금한 말은 농담이다, 농담!"
    ]
    @State var leftSpeaker = true
    @State var step: Int = 0
    @State var indicator: Int = 0
    
    var body: some View {
        ScrollView {
            VStack {
                MessageBox(message: message[step], leftSpeaker: leftSpeaker)
            }
            Button {
                step += 1
                leftSpeaker.toggle()
            } label: {
                Label("next", systemImage: "arrow.right.circle.fill")
            }
        }
    }
}

struct NewCommerView_Previews: PreviewProvider {
    static var previews: some View {
        NewCommerView()
    }
}
