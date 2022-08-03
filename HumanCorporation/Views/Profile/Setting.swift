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
    @State private var showError = false
    @State private var showWarning = false
    
    var body: some View {
        NavigationView{
            List{
                Section("Edit Profile") {
                    Label("Edit Profile Image", systemImage: "person.fill.viewfinder")
                        .onTapGesture {
                            showSheet = true
                        }
                }
                Section {
                    VStack(alignment: .leading){
                        Button {
                            if isValidInput(viewModel.userProfile.name) {
                                viewModel.editProfile()
                                showAlert.toggle()
                            } else {
                                showError.toggle()
                            }
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
                    }
                }
                Button {
                    showWarning.toggle()
                } label: {
                    Label("초기화", systemImage: "trash")
                }
                .buttonStyle(BorderlessButtonStyle())
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                    .onTapGesture {
                        viewModel.signOut()
                    }
            }
            .navigationTitle("Settings")
            .alert("정말 초기화하시겠습니까? 프로필 정보를 제외한 일기, 차트가 모두 초기화됩니다.", isPresented: $showWarning) {
                Button("계속"){
                    viewModel.trashAllExepProfile()
                }
                Button("취소", role: .cancel) {
                    
                }
            }
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary)
                    .environmentObject(viewModel)
            }
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .alert, type: .complete(.green), title:"프로필이 수정되었습니다.")
            }
            .toast(isPresenting: $showError) {
                AlertToast(displayMode: .alert, type: .error(.red), title: "이름 혹은 이메일\n 형식이 잘못됨!")
            }
        }
    }
    func isValidInput(_ Input:String) -> Bool {
        let RegEx = "\\w{2,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
            .environmentObject(ViewModel())
    }
}
