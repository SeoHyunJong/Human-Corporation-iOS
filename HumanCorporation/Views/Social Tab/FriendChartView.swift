//
//  FriendChartView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/03.
//

import SwiftUI

struct FriendChartView: View {
    @EnvironmentObject var viewModel: ViewModel
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
                        Text(profile.name)
                            .font(.system(size: width*0.06))
                            .padding()
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
            .onAppear() {
                viewModel.priceRead(uid: profile.id, mode: .Others, completion: { message in
                    print(message)
                })
            }
            .listStyle(.plain)
        }
    }
}

struct FriendChartView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChartView(profile: Profile(id: "nothing", name: "Tester", email: "nothing", goal: "test preview"))
            .environmentObject(ViewModel())
    }
}
