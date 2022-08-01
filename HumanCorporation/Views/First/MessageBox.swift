//
//  MessageBox.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/01.
//

import SwiftUI

struct MessageBox: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            HStack{
                Image("Mamong")
                    .resizable()
                    .frame(width: width*0.15, height: width*0.15)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 2)
                    }
                    .shadow(radius: 3)
                HStack(spacing: 0) {
                    Triangle()
                        .frame(width: width*0.05, height: width*0.05)
                    Text("반갑다, 인간! 난 마그마그마 행성에서 온 외계투자자 마몽이라고 한다!")
                        .font(.system(size: width*0.05))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                    .cornerRadius(30)
                }
                
            }
            .padding()
        }
        .aspectRatio(2.5,contentMode: .fit)
    }
}

struct MessageBox_Previews: PreviewProvider {
    static var previews: some View {
        MessageBox()
            .previewInterfaceOrientation(.portrait)
    }
}
