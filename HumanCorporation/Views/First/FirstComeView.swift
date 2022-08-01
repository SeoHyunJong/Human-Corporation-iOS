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
            List {
                MessageBox(message: "지구인의 정보가 필요하다! 이상한 곳에 쓰이지 않는다. 내 약속하지. 후후후...", leftSpeaker: true)
                HStack{
                    Text("Name").bold()
                    Divider()
                    TextField("박마몽", text: $profile.name)
                }
                HStack{
                    Text("E-mail").bold()
                    Divider()
                    TextField("mamong@humancorp.com", text: $profile.email)
                }
                HStack{
                    Text("Your Goal").bold()
                    Divider()
                    TextField("21세기 내 지구 정복", text: $profile.goal)
                }
            }
            .listStyle(.plain)
            Button{
                profile.id = GIDSignIn.sharedInstance.currentUser!.userID!;
                viewModel.userAdd(user: profile)
                //button action 내에는 뷰를 불러올 수 없다.
                //따라서 토글을 이용하여 띄울 것이다.
                viewModel.isNewUser.toggle()
            } label: {
                Label("next", systemImage: "arrow.right.circle.fill")
            }
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
