//
//  AuthenticationViewModel.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class ViewModel: ObservableObject {
    lazy var ref = Database.database().reference()
    @Published var isNewUser = false
    // 1
    enum SignInState {
        case signedIn
        case signedOut
    }

    // 2
    @Published var state: SignInState = .signedOut
    
    func signIn() {
      // 1. 이전에 로그인한 이력이 있으면 그 이력을 토대로 로그인한다.
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
        }
      } else {
        // 2. GoogleService-info에 들어있는 clientID를 fetch 한다. 유저 정보 X 이 앱의 정보를 의미
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 3. 이 clientID를 가지고 configuration object를 만든다.
        let configuration = GIDConfiguration(clientID: clientID)
        
        // 4. SwiftUI를 사용하기 때문에 UIViewController가 없다... 이걸 통해 생성한다.
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 5. 이제 로그인을 시작한다. 구글 로그인 뷰를 띄운다.
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
        }
      }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1. 에러 핸들링
        if let error = error {
            print(error.localizedDescription)
            return
        }
          
        // 2. 유저로부터 idToken과 accessToken 받아오기
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        // 3. credential을 넘겨 실질적인 로그인을 진행
        Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
          if let error = error {
            print(error.localizedDescription)
          } else {
              self.state = .signedIn
              userCheck()
          }
        }
    }
    func signOut() {
      // 1
      GIDSignIn.sharedInstance.signOut()
      do {
        // 2
        try Auth.auth().signOut()
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
    
    func userAdd(user: Profile) {
        let values: [String: Any] = ["name":"\(user.name)", "email":"\(user.email)", "goal":"\(user.goal)"]
        self.ref.child("user").child("\(user.id)").setValue(values)
    }
    
    private func userCheck(){
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["name"] as? String ?? "error"
            if username == "error" {
                self.isNewUser = true
            }
        }) { error in
          print(error.localizedDescription)
        }
    }
}
