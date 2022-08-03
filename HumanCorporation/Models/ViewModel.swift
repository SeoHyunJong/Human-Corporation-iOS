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
    @Published var infoNext = false
    @Published var userProfile: Profile = Profile()
    @Published var profileImage = UIImage(named: "Mamong") //프리뷰를 위해 임시 설정
    @Published var priceList: [CandleChartDataEntry] = []
    @Published var recentDay = Date(timeIntervalSince1970: 0)
    
    @Published var tempDiaryList: [Diary] = []
    @Published var tempPriceList: [Double] = []
    
    @Published var diaryListFromFirebase: [Diary] = []
    var diaryListByDate: [Date: [Diary]] {
        //시작 시간을 기준으로 날짜별로 diary를 그룹화.
        Dictionary(
            grouping: diaryListFromFirebase,
            by: {Calendar.current.startOfDay(for: $0.startTime)})
    }
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    @Published var state: SignInState = .signedOut
    
    //----for social----
    @Published var profileOfSearch = Profile()
    @Published var imageOfSearchProfile = UIImage(named: "Mamong")
    @Published var followIDList: [String] = []
    @Published var followProfileList: [Profile] = []
    @Published var profileImgList: [String:UIImage] = [:]
    @Published var followCurrentPriceList: [String:Double] = [:]
    @Published var followOnePriceList: [CandleChartDataEntry] = []
    
    enum KindOfProfile {
        case MyProfile
        case Search
        case Others
    }
    
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
            // 전 사용자의 정보를 보이지 않기 위해 뷰 모델 초기화
            userProfile = Profile()
            profileImage = UIImage(named: "Mamong")
            priceList.removeAll()
            recentDay = Date(timeIntervalSince1970: 0)
            tempDiaryList.removeAll()
            tempPriceList.removeAll()
            diaryListFromFirebase.removeAll()
            profileOfSearch = Profile()
            followIDList.removeAll()
            followProfileList.removeAll()
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
    
    private func userCheck(){ //새로운 유저인지 아닌지 체크
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        ref.child("user").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            guard let _ = snapshot.value as? NSDictionary else {self.isNewUser = true; self.infoNext = false; return}
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func readUserFromDB(uid: String, mode: KindOfProfile, completion: @escaping (_ message: String) -> Void){
        ref.child("user").child(uid).observe(.value, with: { snapshot in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            if mode == .MyProfile {
                self.userProfile.name = value["name"] as? String ?? "로드 실패"
                self.userProfile.goal = value["goal"] as? String ?? "로드 실패"
                self.userProfile.email = value["email"] as? String ?? "로드 실패"
                self.userProfile.id = uid
            } else if mode == .Others {
                let name = value["name"] as? String ?? "로드 실패"
                let goal = value["goal"] as? String ?? "로드 실패"
                let email = value["email"] as? String ?? "로드 실패"
                let id = uid
                self.followProfileList.append(Profile(id: id, name: name, email: email, goal: goal))
            }
            completion("유저의 정보를 읽어옴.")
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func editProfile() {
        self.ref.child("user").child(userProfile.id).updateChildValues(["name":userProfile.name,"goal":userProfile.goal])
    }
    
    func uploadImg(image: UIImage) {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
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
    func downloadImage(uid: String, mode: KindOfProfile){
        let imageRef = storageRef.child("images/\(uid)/profile.jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let _ = error {
                print("cannot load profile image")
            } else {
                if data != nil {
                    if mode == .MyProfile {
                        self.profileImage = UIImage(data: data!)
                    } else if mode == .Search {
                        self.imageOfSearchProfile = UIImage(data: data!)
                    } else if mode == .Others {
                        self.profileImgList[uid] = UIImage(data: data!)
                    }
                }
            }
        }
    }
    func trashAllExepProfile() {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        ref.child("temp").child(uid).removeValue()
        ref.child("price").child(uid).removeValue()
        ref.child("diary").child(uid).removeValue()
        
        priceList.removeAll()
        recentDay = Date(timeIntervalSince1970: 0)
        tempDiaryList.removeAll()
        tempPriceList.removeAll()
        diaryListFromFirebase.removeAll()
    }
    // MARK: Diary
    func diaryAdd(diaryList: [Diary], completion: @escaping (_ message: String) -> Void) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        for diary in diaryList {
            let values: [String: Any] = ["story":diary.story, "startTime":dateformatter.string(from: diary.startTime), "endTime":dateformatter.string(from: diary.endTime), "eval":diary.eval.rawValue]
            self.ref.child("diary").child(userProfile.id).childByAutoId().setValue(values)
        }
        completion("실적이 파이어베이스에 업로드 됨.")
    }
    func readDiaryList(completion: @escaping (_ message: String) -> Void) {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        //최대 100개까지만 읽는다.
        ref.child("diary").child(uid).queryLimited(toFirst: 300).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSDictionary else {return}
                let story = value["story"] as? String
                let startTime = value["startTime"] as? String
                let endTime = value["endTime"] as? String
                let eval = value["eval"] as? String
                let diary = Diary(story: story!, startTime: dateformatter.date(from: startTime!)!, endTime: dateformatter.date(from: endTime!)!, eval: Diary.Evaluation(rawValue: eval!)!)
                self.diaryListFromFirebase.append(diary)
            }
            completion("일기들이 로드됨.")
        }) { error in
            print(error.localizedDescription)
        }
    }
    func addTempDiary() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let diary = self.tempDiaryList.last else {return}//최근에 추가된 다이어리
        let values: [String: Any] = ["story":diary.story, "startTime":dateformatter.string(from: diary.startTime), "endTime":dateformatter.string(from: diary.endTime), "eval":diary.eval.rawValue]
        self.ref.child("temp").child(userProfile.id).child("diary").childByAutoId().setValue(values)
    }
    
    func popTempDiary() {
        self.ref.child("temp").child(userProfile.id).child("diary").observeSingleEvent(of: .value, with: { snapshot in
            guard let child = snapshot.children.allObjects.last as? DataSnapshot else {return}
            let key = child.key
            self.ref.child("temp").child(self.userProfile.id).child("diary").child(key).removeValue()
        })
    }
    
    func readTempDiaryList(completion: @escaping (_ message: String) -> Void) {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        ref.child("temp").child(uid).child("diary").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSDictionary else {return}
                let story = value["story"] as? String
                let startTime = value["startTime"] as? String
                let endTime = value["endTime"] as? String
                let eval = value["eval"] as? String
                let diary = Diary(story: story!, startTime: dateformatter.date(from: startTime!)!, endTime: dateformatter.date(from: endTime!)!, eval: Diary.Evaluation(rawValue: eval!)!)
                self.tempDiaryList.append(diary)
            }
            completion("임시 저장된 일기들이 로드됨.")
        }) { error in
            print(error.localizedDescription)
        }
    }
    func removeTemp() {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        ref.child("temp").child(uid).removeValue()
    }
    func findRecentDay(completion: @escaping (_ message: String) -> Void) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return} //오류가 생겨 guard let 구문으로 처리
        // why 오류? onAppear에서 호출되는 이 함수가 signOut 처리보다 더 늦게 비동기적으로 실행되어 생기는 문제
        ref.child("diary").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let child = snapshot.children.allObjects.last as? DataSnapshot else {return}
            guard let value = child.value as? NSDictionary else {return}
            let endTime = value["endTime"] as? String
            let lastDay = dateformatter.date(from: endTime!)
            let rawRecentDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)!
            
            self.recentDay = Calendar.current.startOfDay(for: rawRecentDay)
            completion("최신 날짜 찾기가 완료됨.")
        }){ error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: Price
    func priceAdd(price: CandleChartDataEntry, completion: @escaping (_ message: String) -> Void) {
        self.priceList.append(price)
        let values: [String: Double?] = ["open": price.open, "close": price.close, "shadowH": price.high, "shadowL": price.low]
        self.ref.child("price").child(userProfile.id).childByAutoId().setValue(values)
        completion("일봉이 파이어베이스에 업로드 됨.")
    }
    
    func addTempPrice() {
        guard let price = self.tempPriceList.last else {return}
        self.ref.child("temp").child(userProfile.id).child("price").childByAutoId().setValue(price)
    }
    
    func popTempPrice() {
        self.ref.child("temp").child(userProfile.id).child("price").observeSingleEvent(of: .value, with: { snapshot in
            guard let child = snapshot.children.allObjects.last as? DataSnapshot else {return}
            let key = child.key
            self.ref.child("temp").child(self.userProfile.id).child("price").child(key).removeValue()
        })
    }
    
    func readTempPriceList(completion: @escaping (_ message: String) -> Void) {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        ref.child("temp").child(uid).child("price").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSNumber else {return}
                self.tempPriceList.append(Double(truncating: value))
            }
            completion("임시 저장된 가격 리스트가 로드됨.")
        })
    }
    
    func priceRead(uid: String, mode: KindOfProfile, completion: @escaping (_ message: String) -> Void){
        ref.child("price").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            var idx: Double = 0
            var tempList:[CandleChartDataEntry] = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSDictionary else {return}
                let open = value["open"] as? Double
                let close = value["close"] as? Double
                let shadowH = value["shadowH"] as? Double
                let shadowL = value["shadowL"] as? Double
                let price = CandleChartDataEntry(x: idx, shadowH: shadowH!, shadowL: shadowL!, open: open!, close: close!)
                tempList.append(price)
                idx += 1
            }
            tempList.sort(by: {$0.x < $1.x})
            if mode == .MyProfile {
                self.priceList = tempList
            } else if mode == .Others {
                self.followOnePriceList = tempList
            }
            completion("가격 정보 로드")
        }) { error in
            print(error.localizedDescription)
        }
    }
    // MARK: Social
    func searchFriend(email: String ,completion: @escaping (_ message: String) -> Void) {
        ref.child("user").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { [self]
            snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSDictionary else {return}
                self.profileOfSearch.id = child.key
                self.profileOfSearch.name = value["name"] as? String ?? ""
                self.downloadImage(uid: child.key, mode: .Search)
            }
        })
        completion("종목 검색 완료.")
    }
    func addFollow(uid: String) {
        self.ref.child("social").child(userProfile.id).child("follow").childByAutoId().setValue(uid)
    }
    func deleteFollow(uid: String) {
        ref.child("social").child(userProfile.id).child("follow").queryOrderedByValue().queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { [self] snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let key = child.key
                ref.child("social").child(userProfile.id).child("follow").child(key).removeValue()
            }
        })
    }
    func readFollowList(completion: @escaping (_ message: String) -> Void) {
        guard let uid = GIDSignIn.sharedInstance.currentUser?.userID else {return}
        ref.child("social").child(uid).child("follow").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = child.value as? NSString else {return}
                self.followIDList.append(value as String)
                self.downloadImage(uid: value as String, mode: .Others)
                self.getRecentPrice(uid: value as String)
                self.readUserFromDB(uid: value as String, mode: .Others, completion: { message in
                    print(message)
                })
            }
            completion("관심종목 id fetch 완료.")
        })
    }
    func getRecentPrice(uid: String){
        ref.child("price").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let child = snapshot.children.allObjects as! [DataSnapshot]
            guard let value = child.last?.value as? NSDictionary else {return}
            let close = value["close"] as? Double
            self.followCurrentPriceList[uid] = close
        }) { error in
            print(error.localizedDescription)
        }
    }
}
