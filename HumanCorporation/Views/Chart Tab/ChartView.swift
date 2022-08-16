//
//  ChartView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//

import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var fluctuation: Double = 0
    @State private var showSetting = false
    
    var body: some View {
        List {
            VStack(alignment: .trailing) {
                Button {
                    showSetting.toggle()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(BorderlessButtonStyle())
                HStack {
                    ProfileImage(image: viewModel.profileImage!)
                        .frame(width: 100, height: 100)
                        .padding(.vertical)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.userProfile.name)
                                .font(.system(size: 20))
                                .fixedSize(horizontal: true, vertical: false)
                            Label(String(format: "%.2f", fluctuation) + "%", systemImage: fluctuation > 0 ? "arrowtriangle.up.circle.fill" : "arrowtriangle.down.circle.fill")
                                .foregroundColor(fluctuation > 0 ? .red : .blue)
                                .scaledToFit()
                                .fixedSize(horizontal: true, vertical: false)
                                .onAppear() {
                                    let current = viewModel.priceList.last?.close ?? 1000
                                    let past_idx = viewModel.priceList.count - 2
                                    var past: Double = 1000
                                    if past_idx >= 0 {
                                        past = viewModel.priceList[past_idx].close
                                    }
                                    fluctuation = (current / past) * 100 - 100
                                }
                        }
                        .padding()
                        Text(viewModel.userProfile.goal)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    Spacer()
                }
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
            VStack {
                MessageBox(message: "상장 가격은 1000원부터 시작한다! 모쪼록 성실하게 일해서 너의 가치를 올리도록!", leftSpeaker: true)
                MessageBox(message: "혹시 내 가격이 오르면 나한테도 배당금 같은거 줘?", leftSpeaker: false)
                MessageBox(message: "...외계인들의 화폐라 지구인들은 쓸 수 없다!", leftSpeaker: true)
            }
        }
        .listStyle(.plain)
        .sheet(isPresented: $showSetting){
            Setting()
                .environmentObject(viewModel)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ViewModel())
    }
}
