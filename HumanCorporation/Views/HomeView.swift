//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var profile: Profile
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: viewModel.signOut){
                    Text("Sign out")
                        .padding()
                }
            }
            Text("Welcome! You're new.")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
            Divider()
            List {
                HStack{
                    Text("Username").bold()
                    Divider()
                }
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(profile: .constant(Profile()))
            .environmentObject(AuthenticationViewModel())
    }
}
