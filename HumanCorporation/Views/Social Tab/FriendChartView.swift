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
    
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            List {
                HStack {
                    ProfileImage(image: viewModel.profileImgList[profile.id] ?? UIImage(named: "Mamong")!)
                        .frame(width: width*0.3, height: width*0.3)
                        .padding(.vertical)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(profile.name)
                                .font(.system(size: width*0.06))
                                .padding()
                            Label(String(format: "%.2f", fluctuation) + "%", systemImage: fluctuation > 0 ? "arrowtriangle.up.circle.fill" : "arrowtriangle.down.circle.fill")
                                .foregroundColor(fluctuation > 0 ? .red : .blue)
                                .scaledToFit()
                                .onChange(of: viewModel.followOnePriceList) { _ in
                                    let current = viewModel.followOnePriceList.last?.close ?? 1000
                                    let past_idx = viewModel.followOnePriceList.count - 2
                                    var past: Double = 1000
                                    if past_idx >= 0 {
                                        past = viewModel.followOnePriceList[past_idx].close
                                    }
                                    fluctuation = (current / past) * 100 - 100
                                }
                        }
                        Text(profile.goal)
                            .font(.system(size: width*0.04))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
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
            .onAppear() {
                viewModel.priceRead(uid: profile.id, mode: .Others, completion: { message in
                    print(message)
                })
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
}

struct FriendChartView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChartView(profile: Profile(id: "nothing", name: "Tester", email: "nothing", goal: "test preview"))
            .environmentObject(ViewModel())
    }
}
