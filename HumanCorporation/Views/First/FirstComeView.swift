//
//  HomeView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import GoogleSignIn
import AlertToast

struct FirstComeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var profile: Profile = Profile()
    @State private var showError = false
    
    var body: some View {
        VStack {
            List {
                MessageBox(message: "지구인의 정보가 필요하다! 이 정보는 너의 프로필에 표시될 것이다. 추후 수정 가능하다!", leftSpeaker: true)
                HStack{
                    Text("Name").bold()
                    Divider()
                    TextField("박마몽(2~10자)", text: $profile.name)
                        .keyboardType(.namePhonePad)
                }
                HStack{
                    Text("Your Goal").bold()
                    Divider()
                    TextField("21세기 내 지구 정복", text: $profile.goal)
                }
            }
            .listStyle(.plain)
            .toast(isPresenting: $showError) {
                AlertToast(displayMode: .alert, type: .error(.red), title: "사람 이름이 맞나요?")
            }
            Button{
                if isValidInput(profile.name) {
                    profile.id = GIDSignIn.sharedInstance.currentUser!.userID!
                    profile.email = GIDSignIn.sharedInstance.currentUser!.profile!.email
                    viewModel.userAdd(user: profile)
                    viewModel.isNewUser.toggle()
                } else {
                    showError.toggle()
                }
            } label: {
                Label("next", systemImage: "arrow.right.circle.fill")
            }
            .padding()
        }
    }
    func isValidInput(_ Input:String) -> Bool {
        let RegEx = "\\w{2,10}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
}

struct FirstComeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstComeView()
            .environmentObject(ViewModel())
    }
}
