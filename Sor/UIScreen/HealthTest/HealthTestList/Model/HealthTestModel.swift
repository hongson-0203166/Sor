//
//  HealthTestModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import Foundation

struct HealthTestModel: Codable {
    var id: String?
    var parentId: String?
    var numberOfTest: Int?
    var image: String?
    var imageDetail: String?
    var description: String?
    var subTitle: String?
    var time: Double?
    var title: String?
    var questions: [HealthTestQuestionModel]?
    var caculateTotalGrade: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, image, description, time, title, questions
        case numberOfTest = "number_of_test"
        case parentId = "parent_id"
        case subTitle = "sub_title"
        case imageDetail = "image_detail"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        parentId = try? container.decode(String.self, forKey: .parentId)
        numberOfTest = try? container.decode(Int.self, forKey: .numberOfTest)
        image = try? container.decode(String.self, forKey: .image)
        imageDetail = try? container.decode(String.self, forKey: .imageDetail)
        description = try? container.decode(String.self, forKey: .description)
        subTitle = try? container.decode(String.self, forKey: .subTitle)
        time = try? container.decode(Double.self, forKey: .time)
        title = try? container.decode(String.self, forKey: .title)
        questions = try? container.decode([HealthTestQuestionModel].self, forKey: .questions)
        
        caculateTotalGrade = getTotalGrade()
    }
}

extension HealthTestModel {
    private func getTotalGrade() -> Int {
        let total = (questions?
            .compactMap { value in
                (value.answers ?? [])
                    .map { $0.grade ?? 0 }
                    .sorted { $0 > $1 }.first ?? 0
            } ?? [])
            .reduce(0, +)
        
        return total
    }
}
