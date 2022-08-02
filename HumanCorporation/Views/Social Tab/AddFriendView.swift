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
                    viewModel.profileOfSearch.name = ""
                    viewModel.imageOfSearchProfile = UIImage(named: "Mamong")
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
            if viewModel.profileOfSearch.name.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.secondary)
            } else {
                HStack(spacing: 20) {
                    ProfileImage(image: viewModel.imageOfSearchProfile!)
                        .frame(width: 50, height: 50)
                    Text(viewModel.profileOfSearch.name)
                    Spacer()
                    Button("Follow") {
                        if viewModel.profileOfSearch.id != viewModel.userProfile.id {
                            viewModel.addFollow(uid: viewModel.profileOfSearch.id)
                        } else {
                            showError.toggle()
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(viewModel.idFollowList.contains(viewModel.profileOfSearch.id) ? true : false)
                }
            }
        }
        .listStyle(.plain)
        .onTapGesture {
            storyFocused = false
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
