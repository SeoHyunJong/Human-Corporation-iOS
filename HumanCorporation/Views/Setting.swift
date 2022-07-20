//
//  Setting.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/20.
//

import SwiftUI

struct Setting: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView{
            Form{
                Label("Edit Profile", systemImage: "person.fill.viewfinder")
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                        viewModel.signOut()
                    }
            }
            .navigationTitle("Settings")
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
            .environmentObject(ViewModel())
    }
}
