//
//  FollowListView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/02.
//

import SwiftUI

struct FollowListView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var fetchCounter = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.followProfileList, id: \.self) { profile in
                    NavigationLink {
                        FriendChartView(profile: profile, fetchCounter: fetchCounter)
                            .onAppear() {
                                fetchCounter = 0
                                viewModel.priceRead(uid: profile.id, mode: .Others, completion: { message in
                                    print(message)
                                    fetchCounter += 1
                                })
                            }
                    } label: {
                        HStack(spacing: 20) {
                            ProfileImage(image: (viewModel.profileImgList[profile.id] ?? UIImage(named: "Mamong"))!)
                                .frame(width: 50, height: 50)
                            Text(profile.name)
                            Spacer()
                            Label(String(format: "%.0f", viewModel.followCurrentPriceList[profile.id] ?? 1000), systemImage: "g.circle.fill")
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Featured")
            .toolbar {
                Button {
                    viewModel.followIDList.removeAll()
                    viewModel.followProfileList.removeAll()
                    viewModel.followCurrentPriceList.removeAll()
                    viewModel.readFollowList(completion: { message in
                        print(message)
                    })
                } label: {
                    Label("새로고침", systemImage: "goforward")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView()
            .environmentObject(ViewModel())
    }
}
