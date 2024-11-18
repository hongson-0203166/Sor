//
//  ArticlesModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 1/10/2024.
//
import Foundation

struct ArticlesModel: Codable {
    let backgroundImage: String
    let id: Int
    let image: String
    let story: [String]
    let title: String
    let url: String
    let timeReading: String
    
    enum CodingKeys: String, CodingKey {
        case backgroundImage = "background_image"
        case timeReading = "time_reading"
        case id, image, story, title, url
    }
}
