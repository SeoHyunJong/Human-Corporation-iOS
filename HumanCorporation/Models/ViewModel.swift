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
import FirebaseStorage
import SwiftUI
import Charts

class ViewModel: ObservableObject {
    // MARK: Property
    lazy var ref = Database.database().reference()
    lazy var storageRef = Storage.storage().reference()
    
    @Published var isNewUser = false
    @Published var userProfile: Profile = Profile()
    @Published var profileImage = UIImage(named: "Mamong") //프리뷰를 위해 임시 설정
    @Published var priceList: [CandleChartDataEntry] = []
    @Published var recentDay = Date(timeIntervalSince1970: 0)
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    @Published var state: SignInState = .signedOut
    
    // MARK: Sign in, sign out
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
    
    // MARK: User profile
    func userAdd(user: Profile) {
        let values: [String: Any] = ["name":"\(user.name)", "email":"\(user.email)", "goal":"\(user.goal)"]
        self.ref.child("user").child("\(user.id)").setValue(values)
        //        uploadImg(image: UIImage(named: "Mamong")!)
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
    
    func readUserFromDB(){
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        ref.child("user").child(uid).observe(.value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.userProfile.name = value?["name"] as? String ?? "로드 실패"
            self.userProfile.goal = value?["goal"] as? String ?? "로드 실패"
            self.userProfile.email = value?["email"] as? String ?? "로드 실패"
            self.userProfile.id = uid
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func editProfile() {
        self.ref.child("user").child(userProfile.id).updateChildValues(["name":userProfile.name,"goal":userProfile.goal,"email":userProfile.email])
    }
    
    func uploadImg(image: UIImage) {
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let imageRef = storageRef.child("images/\(uid)/profile.jpg")
        
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            //            guard let metadata = metadata else {
            //                return
            //            }
            //            imageRef.downloadURL { (url, error) in
            //                guard let downloadURL = url else {
            //                    return
            //                }
            //            }
            self.profileImage = image
        }
    }
    func downloadImage(){
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        let imageRef = storageRef.child("images/\(uid)/profile.jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let _ = error {
                print("cannot load profile image")
            } else {
                if data != nil {
                    self.profileImage = UIImage(data: data!)
                }
            }
        }
    }
    
    // MARK: Diary
    func diaryAdd(diaryList: [Diary]) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        for diary in diaryList {
            let values: [String: Any] = ["story":diary.story, "startTime":dateformatter.string(from: diary.startTime), "endTime":dateformatter.string(from: diary.endTime), "eval":diary.eval.rawValue]
            self.ref.child("diary").child(userProfile.id).childByAutoId().setValue(values)
        }
    }
    
    func findRecentDay() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        ref.child("diary").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            let child = snapshot.children.allObjects.last as! DataSnapshot
            let value = child.value as? NSDictionary
            let endTime = value?["endTime"] as? String
            let lastDay = dateformatter.date(from: endTime!)
            let rawRecentDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)!
            
            self.recentDay = Calendar.current.startOfDay(for: rawRecentDay)
        }){ error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: Price
    func priceAdd(price: CandleChartDataEntry) {
        let values: [String: Double?] = ["open": price.open, "close": price.close, "shadowH": price.high, "shadowL": price.low]
        self.ref.child("price").child(userProfile.id).childByAutoId().setValue(values)
    }
    
    func priceRead(){
        let uid = GIDSignIn.sharedInstance.currentUser!.userID!
        ref.child("price").child(uid).observe(.value, with: { snapshot in
            // Get user value
            var idx: Double = 0
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                let open = value?["open"] as? Double
                let close = value?["close"] as? Double
                let shadowH = value?["shadowH"] as? Double
                let shadowL = value?["shadowL"] as? Double
                let price = CandleChartDataEntry(x: idx, shadowH: shadowH!, shadowL: shadowL!, open: open!, close: close!)
                self.priceList.append(price)
                idx += 1
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
}
