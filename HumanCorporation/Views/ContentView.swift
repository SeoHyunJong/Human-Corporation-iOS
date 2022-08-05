//
//  ContentView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//
//ContentView -> FirstComeView, HomeView, LoginView
import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var fetchCounter: Double = 0
    @State private var completeNum: Double = 5
    
    func setNotification() {
        let manager = LocalNotificationManager()
        manager.requestPermission()
        manager.addNotification(title: "오늘의 일기를 작성해보세요!")
        manager.schedule()
    }
    
    var body: some View {
        switch viewModel.state {
        case .signedIn:
            if viewModel.isNewUser {
                if !viewModel.infoNext {
                    NewCommerView()
                } else {
                    FirstComeView()
                }
            } else {
                HomeView(fetchCounter: fetchCounter, completeNumber: completeNum)
                    .onAppear(){
                        setNotification()
                        fetchCounter = 0
                        if viewModel.state == .signedIn { //프리뷰 오류 때문에 추가...
                            //프로필 로드
                            guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
                            viewModel.readUserFromDB(uid: uid, mode: .MyProfile, completion: { message in
                                print(message)
                                fetchCounter += 1
                            })
                            viewModel.downloadImage(uid: uid, mode: .MyProfile)
                            //차트 데이터 로드
                            viewModel.priceRead(uid: uid, mode: .MyProfile, completion: { message in
                                print(message)
                                fetchCounter += 1
                            })
                            //임시 저장 데이터 로드
                            viewModel.readTempDiaryList(completion: { message in
                                print(message)
                                fetchCounter += 1
                            })
                            //일기장 가져오기
                            viewModel.readDiaryList(completion: { message in
                                print(message)
                                fetchCounter += 1
                            })
                            //친구 목록 불러오기
                            viewModel.readFollowList(completion: { message in
                                print(message)
                                fetchCounter += 1
                            })
                        }
                    }
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
