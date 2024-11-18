//
//  Message.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 03/10/2024.
//

import Foundation

struct Message: Identifiable, Hashable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}
