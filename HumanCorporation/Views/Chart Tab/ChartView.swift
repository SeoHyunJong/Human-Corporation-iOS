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
    var body: some View {
        GeometryReader { geo in
            let width = min(geo.size.width, geo.size.height)
            VStack{
                HStack {
                    ProfileImage(image: viewModel.profileImage!)
                        .frame(width: width*0.3, height: width*0.3)
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
                .padding(.horizontal)
                Bar(entries: viewModel.priceList)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ViewModel())
    }
}
