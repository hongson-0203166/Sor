//
//  HeartBlogModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import Foundation

struct HeartBlogModel: Codable {
    var tests: [HeartBlogTestModel]?
    var diets: [HeartBlogDietModel]?
    var articles: [HeartBlogArticalModel]?
    
    enum CodingKeys: String, CodingKey {
        case articles
        case tests = "healthy_tests"
        case diets = "healthy_diets"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tests = try? container.decode([HeartBlogTestModel].self, forKey: .tests)
        diets = try? container.decode([HeartBlogDietModel].self, forKey: .diets)
        articles = try? container.decode([HeartBlogArticalModel].self, forKey: .articles)
    }
}
