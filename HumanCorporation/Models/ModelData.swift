//
//  Database.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/18.
//

import Foundation
import FirebaseDatabase

final class ModelData: ObservableObject{
    let ref = Database.database().reference()
    
    func userAdd(user: Profile) {
        let values: [String: Any] = ["id":"\(user.id)", "name":"\(user.name)", "email":"\(user.email)", "goal":"\(user.goal)"]
        self.ref.child("user").setValue(values)
    }
}
