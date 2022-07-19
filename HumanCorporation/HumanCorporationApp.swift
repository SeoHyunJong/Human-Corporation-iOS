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
    @StateObject var db = ModelData()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(db)
        }
    }
}
