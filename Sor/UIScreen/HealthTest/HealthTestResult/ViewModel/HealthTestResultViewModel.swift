//
//  HealthTestResultViewModel.swift
//  HeartCare
//
//  Created by Admin on 26/6/24.
//

import Foundation

class HealthTestResultViewModel {
    let data: HealthTestModel
    
    enum EvaluateType {
        case low
        case medium
        case high
    }
    
    init(data: HealthTestModel) {
        self.data = data
    }
    
    var currentGrade: Int {
        let total = (data.questions?
            .map { value in
                value.selectedAnswer?.grade ?? 0
            } ?? [])
            .reduce(0, +)
        
        return total
    }
    
    func evaluateMin() -> (min: Int, max: Int) {
        let max = Int((data.caculateTotalGrade ?? 0) / 3)
        return (0, max)
    }
    
    func evaluateMax() -> (min: Int, max: Int) {
        let min = Int((data.caculateTotalGrade ?? 0) / 3) + 1
        let max = Int((data.caculateTotalGrade ?? 0) / 3 * 2)
        
        return (min, max)
    }
    
    func evaluateHigh() -> (min: Int, max: Int) {
        let min = Int((data.caculateTotalGrade ?? 0) / 3 * 2) + 1
        let max = Int(data.caculateTotalGrade ?? 0)
        
        return (min, max)
    }
    
    func evaluate() -> (text: String, type: EvaluateType) {
        if evaluateMin().min <= currentGrade && currentGrade <= evaluateMin().max {
            return ("Maintain healthy habits and consider preventative measures.", .low)
        } else if evaluateMax().min <= currentGrade && currentGrade <= evaluateMax().max {
            return ("Talk to your doctor about creating a personalized risk reduction plan.", .medium)
        } else {
            return ("Schedule a consultation with your doctor to discuss potential interventions and a heart-healthy lifestyle plan.", .high)
        }
    }
}
