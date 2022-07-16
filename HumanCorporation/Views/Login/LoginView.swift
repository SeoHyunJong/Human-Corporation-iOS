//
//  LoginView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .center){
            Image("Mamong")
            Text("Human Corporation")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
            Text("Sign with social login.")
                .font(.system(size: 20))
                .foregroundColor(.gray)
            Spacer()
            
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
