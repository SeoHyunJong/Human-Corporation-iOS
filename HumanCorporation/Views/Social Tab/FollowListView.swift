//
//  FollowListView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/02.
//

import SwiftUI

struct FollowListView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.followList, id: \.self) { profile in
                    HStack(spacing: 20) {
                        ProfileImage(image: (viewModel.profileImgList[profile.id] ?? UIImage(named: "Mamong"))!)
                            .frame(width: 50, height: 50)
                        Text(profile.name)
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Featured")
            .toolbar {
                Button {
                    viewModel.profileImgList.removeAll()
                    viewModel.idFollowList.removeAll()
                    viewModel.followList.removeAll()
                    viewModel.readFollowList(completion: { message in
                        print(message)
                    })
                } label: {
                    Label("새로고침", systemImage: "goforward")
                }
            }
        }
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView()
            .environmentObject(ViewModel())
    }
}
