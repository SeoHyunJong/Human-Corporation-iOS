//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import GoogleSignIn

struct FirstComeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var profile: Profile = Profile()
    var body: some View {
        VStack {
            Label("Welcome!", systemImage: "face.smiling")
                .font(.system(size: 30, weight: .bold))
                .offset(x: -80)
            List {
                HStack{
                    Text("Name").bold()
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
            Button{
                profile.id = GIDSignIn.sharedInstance.currentUser!.userID!;
                viewModel.userAdd(user: profile)
                //button action 내에는 뷰를 불러올 수 없다.
                //따라서 토글을 이용하여 띄울 것이다.
                viewModel.isNewUser.toggle()
            } label: {
                Text("확인")
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

struct FirstComeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstComeView()
            .environmentObject(ViewModel())
    }
}
