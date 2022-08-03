//
//  LoadingView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/04.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading...")
                .bold()
                .font(.system(size: 30))
                .padding()
            MessageBox(message: "파이어베이스에서 데이터를 가져오는 중이다!", leftSpeaker: true)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}