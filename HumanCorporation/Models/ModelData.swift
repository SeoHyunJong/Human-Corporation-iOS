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
    
    func userAdd(id: String, name: String, email: String, goal: String) {
        let values: [String: Any] = ["id":"\(id)", "name":"\(name)", "email":"\(email)", "goal":"\(goal)"]
        self.ref.child("user").setValue(values)
    }
}
