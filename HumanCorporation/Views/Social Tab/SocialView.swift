//
//  DiscussionView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
/*
 팔로우     추가   팔로워(push 메세지)   편집
 <팔로우>
 친구프사  이름  현재가격
 [이벤트: 클릭시]
 차트뷰에 친구 정보 삽입
 <추가>
 이메일로 검색    검색 버튼
 친구프사  이름   Follow
 */
import SwiftUI

struct SocialView: View {
    @State private var selection: Tab = .FollowList
    @EnvironmentObject var viewModel: ViewModel
    
    enum Tab {
        case FollowList
        case AddFriend
    }
    
    var body: some View {
        TabView(selection: $selection) {
            FollowListView()
                .tabItem{
                    Label("관심종목", systemImage: "star.fill")
                }
                .tag(Tab.FollowList)
            AddFriendView()
                .tabItem{
                    Label("종목추가", systemImage: "person.badge.plus")
                }
                .tag(Tab.AddFriend)
        }
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
            .environmentObject(ViewModel())
    }
}
