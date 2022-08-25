//
//  FriendChartView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/03.
//

import SwiftUI

struct FriendChartView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var fluctuation: Double = 0
    @State private var showAlert = false
    var profile: Profile
    var fetchCounter: Int
    
    var body: some View {
        List {
            HStack {
                ProfileImage(image: viewModel.profileImgList[profile.id] ?? UIImage(named: "Mamong")!)
                    .frame(width: 100, height: 100)
                    .padding(.vertical)
                VStack(alignment: .leading) {
                    HStack {
                        Text(profile.name)
                            .font(.system(size: 20))
                            .padding()
                            .fixedSize(horizontal: true, vertical: false)
                        if fetchCounter > 0 {
                            Label(String(format: "%.2f", fluctuation) + "%", systemImage: fluctuation > 0 ? "arrowtriangle.up.circle.fill" : "arrowtriangle.down.circle.fill")
                                .foregroundColor(fluctuation > 0 ? .red : .blue)
                                .fixedSize(horizontal: true, vertical: false)
                                .onAppear(){
                                    let current = viewModel.followOnePriceList.last?.close ?? 1000
                                    let past_idx = viewModel.followOnePriceList.count - 2
                                    var past: Double = 1000
                                    if past_idx >= 0 {
                                        past = viewModel.followOnePriceList[past_idx].close
                                    }
                                    fluctuation = (current / past) * 100 - 100
                            }
                        }
                    }
                    Text(profile.goal)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .fixedSize(horizontal: true, vertical: false)
                }
                Spacer()
            }
            Bar(entries: viewModel.followOnePriceList)
                .scaledToFit()
            HStack(spacing: 30){
                Label("현재 가치", systemImage: "c.circle.fill")
                Spacer()
                Divider()
                let current = viewModel.followOnePriceList.last?.close ?? 1000
                Text(String(format: "%.0f", current) + " ₩")
            }
            .padding(.horizontal)
            .foregroundColor(.primary)
            HStack(spacing: 30){
                Label("52주 최고가격", systemImage: "h.circle.fill")
                Spacer()
                Divider()
                let high = viewModel.followOnePriceList.max{a, b in a.high < b.high}?.high ?? 1000
                Text(String(format: "%.0f", high) + " ₩")
            }
            .padding(.horizontal)
            .foregroundColor(.red)
            HStack(spacing: 30){
                Label("52주 최저가격", systemImage: "l.circle.fill")
                Spacer()
                Divider()
                let low = viewModel.followOnePriceList.min{a, b in a.low < b.low}?.low ?? 1000
                Text(String(format: "%.0f", low) + " ₩")
            }
            .padding(.horizontal)
            .foregroundColor(.blue)
        }
        .navigationTitle(profile.name)
        .toolbar{
            Button {
                showAlert.toggle()
            } label: {
                Label("팔로우 취소", systemImage: "person.badge.minus")
            }
        }
        .listStyle(.plain)
        .alert("해당 종목을 언팔로우하시겠습니까?", isPresented: $showAlert) {
            Button("Unfollow") {
                viewModel.deleteFollow(uid: profile.id)
                viewModel.followIDList = viewModel.followIDList.filter(){$0 != profile.id}
                viewModel.followProfileList = viewModel.followProfileList.filter(){$0 != profile}
            }
            Button("취소", role: .cancel) {
            }
        }
    }
}

struct FriendChartView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChartView(profile: Profile(id: "nothing", name: "Tester", email: "nothing", goal: "test preview"), fetchCounter: 1)
            .environmentObject(ViewModel())
    }
}
