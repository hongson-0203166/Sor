//
//  HealthTestQuestionModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import Foundation

struct HealthTestQuestionModel: Codable {
    var page: Int?
    var question: String?
    var answers: [HealthTestAnswerModel]?
    var selectedAnswer: HealthTestAnswerModel?
}
