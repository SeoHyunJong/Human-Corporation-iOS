//
//  GoogleSignInButton.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: UIViewRepresentable { //SwiftUI와 합쳐지고 싶을때 쓰이는 UIKit 뷰
    @Environment(\.colorScheme) var colorScheme
     
     private var button = GIDSignInButton() //sign in with Google

     func makeUIView(context: Context) -> GIDSignInButton {
       button.colorScheme = colorScheme == .dark ? .dark : .light
       return button
     }

     func updateUIView(_ uiView: UIViewType, context: Context) {
       button.colorScheme = colorScheme == .dark ? .dark : .light
     }
}
