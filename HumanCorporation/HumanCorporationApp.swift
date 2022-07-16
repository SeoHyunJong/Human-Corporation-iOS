//
//  HumanCorporationApp.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import Firebase

@main
struct HumanCorporationApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    //흠... 유저가 로그인한 정보가 @StateObject의 부가적인 효과로 인해 일종의 싱글턴이 된거로군?!
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
