//
//  ReceiptModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 15/09/2024.
//

import Foundation

struct ReceiptModel: Codable {
    let sources: String?
    let calo: Int?
    let category: ReceiptCategory?
    let cooks: [String]?
    let id: Int?
    let ingres: [String]?
    let name: String?
    let serve, timeCost: Int?
    let image: String?
    let protein: Double?
    let sodium, fat, sugar: Int?
    let rate: Double?

    enum CodingKeys: String, CodingKey {
        case sources, calo, cooks, id, ingres, name, serve, image, rate
        case timeCost = "time_cost"
        case protein, sodium, fat, sugar
        case category = "cate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int.self, forKey: .id)
        calo = try? container.decode(Int.self, forKey: .calo)
        sources = try? container.decode(String.self, forKey: .sources)
        name = try? container.decode(String.self, forKey: .name)
        serve = try? container.decode(Int.self, forKey: .serve)
        image = try? container.decode(String.self, forKey: .image)
        timeCost = try? container.decode(Int.self, forKey: .timeCost)
        protein = try? container.decode(Double.self, forKey: .protein)
        sodium = try? container.decode(Int.self, forKey: .sodium)
        fat = try? container.decode(Int.self, forKey: .fat)
        sugar = try? container.decode(Int.self, forKey: .sugar)
        rate = try? container.decode(Double.self, forKey: .rate)
        ingres = try? container.decode([String].self, forKey: .ingres)
        cooks = try? container.decode([String].self, forKey: .cooks)
        category = try? container.decode(ReceiptCategory.self, forKey: .category)
    }
}

enum ReceiptCategory: String, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case all
}
