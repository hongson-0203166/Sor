//
//  Extension+String.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 11/09/2024.
//

import Foundation

extension String {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }

    var length: Int {
        return self.count
    }
}
