//
//  Date.swift
//  SwiftCustomCalendar
//
//  Created by Umair Afzal on 3/19/18.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: self)
        }

    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }

    func isWeekend() -> Bool {
        return Date.calendar.isDateInWeekend(self)
    }
}
extension Date {
    func toStringMedium() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = Locale(identifier: "EN")
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
