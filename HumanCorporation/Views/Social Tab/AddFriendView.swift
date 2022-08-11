//
//  AddFriendView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/02.
//

import SwiftUI
import AlertToast

struct AddFriendView: View {
    @State private var searchEmail = ""
    @FocusState private var storyFocused: Bool
    @EnvironmentObject var viewModel: ViewModel
    @State private var showError = false
    @State private var showAlert = false
    @State private var uid: String?
    
    var body: some View {
        List {
            HStack{
                ZStack{
                    TextField("     이메일로 친구 추가", text: $searchEmail)
                        .keyboardType(.emailAddress)
                        .focused($storyFocused)
                    Rectangle()
                        .fill(.clear)
                        .border(.orange, width: 1)
                }
                .padding(.horizontal)
                Button {
                    viewModel.profileOfSearch.removeAll()
                    viewModel.imageOfSearchProfile.removeAll()
                    storyFocused = false
                    viewModel.searchFriend(email: searchEmail, completion: { message in
                        print(message)
                    })
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .foregroundColor(.orange)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            if viewModel.profileOfSearch.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.profileOfSearch, id: \.self.id) { profile in
                    HStack(spacing: 20) {
                        ProfileImage(image: viewModel.imageOfSearchProfile[profile.id] ?? UIImage(named: "Mamong")!)
                            .frame(width: 50, height: 50)
                        Text(profile.name)
                        Spacer()
                        Button("Follow") {
                            uid = profile.id
                            showAlert.toggle()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(viewModel.followIDList.contains(profile.id) ? true : false)
                    }
                }
            }
            MessageBox(message: "개발자 이메일: shj971219@gmail.com\n추가해서 테스트해봐!", leftSpeaker: true)
        }
        .listStyle(.plain)
        .onTapGesture {
            storyFocused = false
        }
        .alert("정말 이 종목을 관심종목에 추가하시겠습니까?", isPresented: $showAlert) {
            Button("추가") {
                if uid != viewModel.userProfile.id {
                    viewModel.addFollow(uid: uid!)
                    //친구 리스트 갱신
                    viewModel.followIDList.append(uid!)
                    viewModel.downloadImage(uid: uid!, mode: .Others)
                    viewModel.getRecentPrice(uid: uid!)
                    viewModel.readUserFromDB(uid: uid!, mode: .Others, completion: { message in
                        print(message)
                    })
                } else {
                    showError.toggle()
                }
            }
            Button("취소", role: .cancel) {
            }
        }
        .toast(isPresenting: $showError) {
            AlertToast(displayMode: .alert, type: .error(.red), title: "자기 자신을 팔로우\n할 수 없습니다.")
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFriendView()
                .environmentObject(ViewModel())
        }
    }
}
