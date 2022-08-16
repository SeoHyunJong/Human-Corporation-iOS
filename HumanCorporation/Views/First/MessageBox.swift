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
        HStack{
            if leftSpeaker {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                    Image("Mamong")
                        .resizable()
                        .frame(width: 60, height: 60)
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
                        .frame(width: 20, height: 20)
                }
                Text(message)
                    .font(.system(size: 18))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white)
                    .padding()
                    .background(leftSpeaker ? Color.blue : Color.green)
                    .cornerRadius(30)
                if !leftSpeaker {
                    Triangle(color: Color.green)
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(180))
                } else {
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct MessageBox_Previews: PreviewProvider {
    static var previews: some View {
        MessageBox(message: "뭘 봐!", leftSpeaker: true)
            .previewInterfaceOrientation(.portrait)
    }
}
