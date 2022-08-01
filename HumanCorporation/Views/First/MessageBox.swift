//
//  MessageBox.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct MessageBox: View {
    var message: String
    var leftSpeaker: Bool
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack{
                if leftSpeaker {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: width*0.15, height: width*0.15)
                        Image("Mamong")
                            .resizable()
                            .frame(width: width*0.15, height: width*0.15)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 2)
                            }
                        .shadow(radius: 3)
                    }
                } else {
                    Spacer()
                }
                HStack(spacing: -5) {
                    if leftSpeaker {
                        Triangle(color: Color.blue)
                            .frame(width: width*0.05, height: width*0.05)
                    }
                    Text(message)
                        .font(.system(size: width*0.045))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.white)
                        .padding()
                        .background(leftSpeaker ? Color.blue : Color.green)
                        .cornerRadius(30)
                    if !leftSpeaker {
                        Triangle(color: Color.green)
                            .frame(width: width*0.05, height: width*0.05)
                            .rotationEffect(.degrees(180))
                    }
                }
                
            }
            .padding()
        }
        .aspectRatio(2.5,contentMode: .fit)
    }
}

struct MessageBox_Previews: PreviewProvider {
    static var previews: some View {
        MessageBox(message: "환영한다, 인간! 난 외계행성에서 온 외계투자자 마몽이라고 한다! 이 앱을 개발했지!", leftSpeaker: true)
            .previewInterfaceOrientation(.portrait)
    }
}
