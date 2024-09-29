//
//  HealthTestQuestionModel.swift
//  HeartCare
//
//  Created by Admin on 25/6/24.
//

import Foundation

struct HealthTestQuestionModel: Codable {
    var page: Int?
    var question: String?
    var answers: [HealthTestAnswerModel]?
    var selectedAnswer: HealthTestAnswerModel?
}
