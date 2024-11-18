//
//  HeartBlogTestModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import Foundation

struct HeartBlogTestModel: Codable {
    var id: String?
    var imageUrl: String?
    var numberOfCate: Int?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case imageUrl = "image_url"
        case numberOfCate = "number_of_category"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        title = try? container.decode(String.self, forKey: .title)
        numberOfCate = try? container.decode(Int.self, forKey: .numberOfCate)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
    }
}
