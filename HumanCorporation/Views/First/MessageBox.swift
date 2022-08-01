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
                    Image("Mamong")
                        .resizable()
                        .frame(width: width*0.15, height: width*0.15)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 2)
                        }
                        .shadow(radius: 3)
                } else {
                    Spacer()
                }
                HStack(spacing: -5) {
                    if leftSpeaker {
                        Triangle(color: Color.blue)
                            .frame(width: width*0.05, height: width*0.05)
                    }
                    Text(message)
                        .font(.system(size: width*0.05))
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
        MessageBox(message: "외계투자자...??", leftSpeaker: false)
            .previewInterfaceOrientation(.portrait)
    }
}
