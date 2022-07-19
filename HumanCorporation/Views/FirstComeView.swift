//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import GoogleSignIn

struct FirstComeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var profile: Profile
    var body: some View {
        VStack {
            Text("Welcome! You're new.")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
            Divider()
            List {
                HStack{
                    Text("Username").bold()
                    Divider()
                    TextField("Username", text: $profile.name)
                }
                HStack{
                    Text("E-mail").bold()
                    Divider()
                    TextField("E-mail", text: $profile.email)
                }
                HStack{
                    Text("Your Goal").bold()
                    Divider()
                    TextField("Your Goal", text: $profile.goal)
                }
            }
            Button(action: viewModel.signOut){
                Text("확인")
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstComeView(profile: .constant(Profile()))
            .environmentObject(AuthenticationViewModel())
    }
}
