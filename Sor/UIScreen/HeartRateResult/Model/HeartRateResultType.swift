//
//  HeartRateResultType.swift
//  HeartCare
//
//  Created by Admin on 9/7/24.
//

import UIKit

enum HeartRateResultType {
    case low
    case normal
    case high
    
    static func getType(pulse: Double) -> Self {
        if pulse < 60 {
            return .low
        } else if pulse >= 60 && pulse < 101 {
            return .normal
        } else {
            return .high
        }
    }
    
    var value: (text: String, color: UIColor) {
        switch self {
        case .low:
            return ("Low", UIColor(hex: 0xF87B2C))
        case .normal:
            return ("Normal", UIColor(hex: 0x30C7A3))
        case .high:
            return ("High", UIColor(hex: 0xE2465C))
        }
    }
    
    var encouragement: String {
        switch self {
        case .low:
            return "Your heart rate is lower than normal, which could be due to various factors."
        case .normal:
            return "Your heart rate is within the normal range, indicating that your cardiovascular system is functioning well."
        case .high:
            return "Your heart rate is higher than normal, which could be due to stress, physical activity, or health issues."
        }
    }
    
    var suggestions: [String] {
        switch self {
        case .low:
            return [
                "If you feel fatigued or dizzy, please consult a doctor.",
                "Use the health tests in the app to monitor your condition and get additional insights.",
                "Explore healthy diet plans in the app to ensure you maintain a balanced and energy-boosting diet.",
                "Keep track of your heart rate in different situations and record any changes."
            ]
        case .normal:
            return [
                "Continue to maintain a healthy lifestyle and take advantage of the app’s features to optimize your health.",
                "Use the app’s health tests regularly to monitor other health metrics and maintain stability.",
                "Explore the healthy diet plans in the app to support a balanced diet and cardiovascular health."
            ]
        case .high:
            return [
                "If the high heart rate persists or is accompanied by symptoms like chest pain or shortness of breath, seek medical attention immediately.",
                "Use the health tests in the app to assess your condition and identify potential causes of the elevated heart rate.",
                "Explore the app’s healthy diet plans and stress-reducing exercises to help manage your heart rate and improve overall health.",
                "Try the relaxation techniques available in the app to help lower your heart rate and reduce stress."
            ]
        }
    }
}
