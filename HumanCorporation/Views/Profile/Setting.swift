//
//  Setting.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/20.
// Setting -> ImagePicker
import SwiftUI
struct Setting: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showSheet = false
    var body: some View {
        NavigationView{
            Form{
                Section("Edit Profile") {
                    Label("Edit Profile Image", systemImage: "person.fill.viewfinder")
                            .onTapGesture {
                                showSheet = true
                        }
                }
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                        viewModel.signOut()
                    }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary)
                    .environmentObject(viewModel)
            }
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
            .environmentObject(ViewModel())
    }
}
