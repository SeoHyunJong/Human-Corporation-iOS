//
//  LoginView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            VStack(alignment: .center){
                Image("Mamong")
                    .resizable()
                    .frame(width: width*0.5, height: width*0.5)
                Text("Human Corporation")
                    .font(.system(size: width*0.06, weight: .bold))
                    .padding()
                Text("Sign with social login.")
                    .font(.system(size: width*0.03, design: .monospaced))
                    .foregroundColor(.secondary)
                GoogleSignInButton()
                    .frame(width: width*0.8, height: width*0.15)
                    .padding()
                    .onTapGesture {
                        viewModel.signIn()
                    }
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            //geometry reader를 쓰고나면 꼭 컨테이너 크기를 리폼해줘야 한다.
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}
