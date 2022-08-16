//
//  LoginView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/16.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var currentNonce: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center){
                Image("MamongChart")
                    .resizable()
                    .frame(width: 300, height: 300)
                Text("Human Corporation")
                    .font(.system(size: 20, weight: .bold))
                Text("Sign with social login.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                GoogleSignInButton()
                    .frame(width: 305, height: 44)
                    .onTapGesture {
                        viewModel.signIn()
                    }
                SignInWithAppleButton(
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                guard let nonce = currentNonce else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                }
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }
                                
                                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        viewModel.state = .signedIn
                                        viewModel.userCheck(uid: Auth.auth().currentUser!.uid)
                                        viewModel.userProfile.platform = "apple"
                                    }
                                }
                            default:
                                break
                                
                            }
                        default:
                            break
                        }
                    }
                )
                .frame(width: 300, height: 44)
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                Spacer()
            }
            //geometry reader를 쓰고나면 꼭 컨테이너 크기를 리폼해줘야 한다.
        }
    }
    // MARK: Apple Sign In
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}
