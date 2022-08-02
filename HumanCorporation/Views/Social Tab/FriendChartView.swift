//
//  FriendChartView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/03.
//

import SwiftUI

struct FriendChartView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            List {
                HStack {
                    ProfileImage(image: viewModel.profileImage!)
                        .frame(width: width*0.3, height: width*0.3)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(viewModel.userProfile.name)
                            .font(.system(size: width*0.06))
                            .padding()
                        Text(viewModel.userProfile.goal)
                            .font(.system(size: width*0.04))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                Bar(entries: viewModel.priceList)
                    .scaledToFit()
                HStack(spacing: 30){
                    Label("현재 나의 가치", systemImage: "c.circle.fill")
                    Spacer()
                    Divider()
                    let current = viewModel.priceList.last?.close ?? 1000
                    Text(String(format: "%.0f", current) + " ₩")
                }
                .padding(.horizontal)
                .foregroundColor(.primary)
                HStack(spacing: 30){
                    Label("52주 최고가격", systemImage: "h.circle.fill")
                    Spacer()
                    Divider()
                    let high = viewModel.priceList.max{a, b in a.high < b.high}?.high ?? 1000
                    Text(String(format: "%.0f", high) + " ₩")
                }
                .padding(.horizontal)
                .foregroundColor(.red)
                HStack(spacing: 30){
                    Label("52주 최저가격", systemImage: "l.circle.fill")
                    Spacer()
                    Divider()
                    let low = viewModel.priceList.min{a, b in a.low < b.low}?.low ?? 1000
                    Text(String(format: "%.0f", low) + " ₩")
                }
                .padding(.horizontal)
                .foregroundColor(.blue)
                MessageBox(message: "상장 가격은 1000원부터 시작한다! 모쪼록 성실하게 일해서 너의 가치를 올리도록!", leftSpeaker: true)
                MessageBox(message: "혹시 내 가격이 오르면 나한테도 배당금 같은거 줘?", leftSpeaker: false)
                MessageBox(message: "...외계인들의 화폐라 지구인들은 쓸 수 없다!", leftSpeaker: true)
                
                
            }
            .listStyle(.plain)
        }
    }
}

struct FriendChartView_Previews: PreviewProvider {
    static var previews: some View {
        FriendChartView()
            .environmentObject(ViewModel())
    }
}