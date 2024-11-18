//
//  HeartRateResultViewModel.swift
//  HeartCare
//
//  Created by Admin on 9/7/24.
//

import Foundation

class HeartRateResultViewModel {
    let maxPulse: Double = 140
    var pushWhenDismiss = true
    
    let model: NewHeartRateModel
    
    init(model: NewHeartRateModel) {
        self.model = model
    }
}
