//
//  Profile.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/18.
//

import Foundation
import GoogleSignIn

struct Profile: Codable, Hashable, Identifiable {
    var id = "eriel123"
    var name = "박두루미"
    var email = "durumi123@humancorp.com"
    var goal = "부자가 되는게 꿈이에요."
}
