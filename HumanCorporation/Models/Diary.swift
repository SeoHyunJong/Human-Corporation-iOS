//
//  Diary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/25.
//

import Foundation

struct Diary {
    var story: String
    var startTime: Date
    var endTime: Date
    
    enum Evaluation: String {
        case productive = "productive"
        case unproductive = "unproductive"
        case neutral = "neutral"
    }
    var eval = Evaluation.neutral
}
