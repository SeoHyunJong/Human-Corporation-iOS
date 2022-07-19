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
    var goal = "목표를 적어주세요. ex)20XX년 CPA 합격"
}
