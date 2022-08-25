//
//  ApiModel.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/17.
//

import Foundation

struct TaskEntry: Codable {
    let id: Int
    let node_id: String
    let name: String
}

struct Commit: Codable {
    let node_id: String
    let commit: commit
    struct commit: Codable {
        let committer: committer
        struct committer: Codable {
            let name: String
            let email: String
            let date: String
        }
        let message: String
    }
}

struct Summoner: Codable {
    let puuid: String
}
