//
//  Setting.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/20.
// Setting -> ImagePicker
import SwiftUI
import AlertToast

struct Setting: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showSheet = false
    @State private var showAlert = false
    var body: some View {
        NavigationView{
            Form{
                Section("Edit Profile") {
                    Label("Edit Profile Image", systemImage: "person.fill.viewfinder")
                        .onTapGesture {
                            showSheet = true
                        }
                }
                Section {
                    VStack(alignment: .leading){
                        Button {
                            viewModel.editProfile()
                            showAlert.toggle()
                        } label: {
                            Label("Edit Profile", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        HStack {
                            Text("Name")
                                .bold()
                            Divider()
                            TextField("Name", text: $viewModel.userProfile.name)
                            Spacer()
                        }
                        HStack {
                            Text("Goal")
                                .bold()
                            Divider()
                            TextField("goal", text: $viewModel.userProfile.goal)
                            Spacer()
                        }
                        HStack {
                            Text("E-mail")
                                .bold()
                            Divider()
                            TextField("email", text: $viewModel.userProfile.email)
                            Spacer()
                        }
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
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .alert, type: .complete(.green), title:"프로필이 수정되었습니다.")
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
