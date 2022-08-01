//
//  ContentView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//
//ContentView -> FirstComeView, HomeView, LoginView
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var infoNext = false
    var body: some View {
        switch viewModel.state {
        case .signedIn:
            if viewModel.isNewUser {
                if !infoNext {
                    NewCommerView(infoNext: $infoNext)
                } else {
                    FirstComeView()
                }
            } else {
                HomeView()
            }
        case .signedOut: LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
