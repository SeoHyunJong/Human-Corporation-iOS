//
//  LoadingView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/04.
//

import SwiftUI

struct LoadingView: View {
    var fetchCounter: Double
    var completeNumber: Double
    var body: some View {
        VStack {
            Image("MamongChart")
                .resizable()
                .frame(width:200, height: 200)
            Text("Loading...")
                .bold()
                .font(.system(size: 30))
                .padding()
            ProgressView(value: fetchCounter, total: completeNumber)
                .padding()
                .tint(.blue)
                .frame(width: 300)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(fetchCounter: 3, completeNumber: 5)
    }
}
