//
//  ContentView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var profile = Profile()
    var body: some View {
        switch viewModel.state {
          case .signedIn:
            HomeView(profile: $profile)
          case .signedOut: LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(profile: Profile())
            .environmentObject(AuthenticationViewModel())
    }
}
