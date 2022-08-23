//
//  Diary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/25.
//

import Foundation

struct Diary: Equatable, Hashable {
    var story: String
    var startTime: Date
    var endTime: Date
    enum Evaluation: String, Equatable {
        case productive = "productive"
        case unproductive = "unproductive"
        case neutral = "neutral"
        case cancel = "cancel"
        
        static func == (lhs: Self, rhs: Self) -> Bool {
               switch (lhs, rhs) {
               case (.productive, .productive),
                    (.unproductive, .unproductive),
                    (.neutral, .neutral):
                   return true
               default:
                   return false
               }
           }
    }
    var eval = Evaluation.neutral
    var concentration: Double = 2
}
