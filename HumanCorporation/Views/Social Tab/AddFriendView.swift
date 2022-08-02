//
//  AddFriendView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/02.
//

import SwiftUI

struct AddFriendView: View {
    @State private var nameOfFriend = ""
    @State private var imgOfFriend = UIImage(named: "Mamong")
    @State private var searchEmail = ""
    @FocusState private var storyFocused: Bool
    
    var body: some View {
        List {
            HStack{
                ZStack{
                    TextField("     이메일로 종목 추가", text: $searchEmail)
                        .keyboardType(.emailAddress)
                        .focused($storyFocused)
                    Rectangle()
                        .fill(.clear)
                        .border(.orange, width: 1)
                }
                .padding(.horizontal)
                Button {
                    storyFocused = false
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .foregroundColor(.orange)
                }
            }
            if nameOfFriend.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.secondary)
            } else {
                HStack(spacing: 20) {
                    ProfileImage(image: imgOfFriend!)
                    Text(nameOfFriend)
                    Spacer()
                    Button("Follow") {
                        
                    }
                }
            }
        }
        .listStyle(.plain)
        .onTapGesture {
            storyFocused = false
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}
