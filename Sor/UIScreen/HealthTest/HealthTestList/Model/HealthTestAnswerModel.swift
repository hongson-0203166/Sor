//
//  HealthTestAnswerModel.swift
//  HeartCare
//
//  Created by Admin on 25/6/24.
//

import Foundation

struct HealthTestAnswerModel: Codable, Equatable {
    var answer: String?
    var grade: Int?
    
    static func == (lhs: HealthTestAnswerModel, rhs: HealthTestAnswerModel) -> Bool {
        return lhs.answer == rhs.answer && lhs.grade == rhs.grade
    }
}
