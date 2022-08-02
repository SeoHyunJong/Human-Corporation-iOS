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
                ForEach() { uid in
                    
                }
            }
            .onAppear() {
                viewModel.readFollowList(completion: { message in
                    print(message)
                })
            }
        }
        .navigationTitle("Featured")
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView()
            .environmentObject(ViewModel())
    }
}
