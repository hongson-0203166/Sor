//
//  HealthTestAnswerModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import Foundation

struct HealthTestAnswerModel: Codable, Equatable {
    var answer: String?
    var grade: Int?
    
    static func == (lhs: HealthTestAnswerModel, rhs: HealthTestAnswerModel) -> Bool {
        return lhs.answer == rhs.answer && lhs.grade == rhs.grade
    }
}
