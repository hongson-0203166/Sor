//
//  HealthyDietDetailViewModel.swift
//  HeartCare
//
//  Created by Admin on 26/06/2024.
//

import Foundation

class HealthyDietDetailViewModel {
    let ingredientsColor = [
        R.color.color_42C6FC(),
        R.color.color_4ACB7E(),
        R.color.color_FDCD29(),
        R.color.color_E2485C(),
        R.color.color_9747FF(),
        R.color.color_4ACB7E(),
        R.color.color_F16923(),
        R.color.color_7C7C7C(),
    ]
}

extension HealthyDietDetailViewModel {
    func getHostLink(_ link: String?) -> String {
        guard let link, let url = URL(string: link) else {
            return ""
        }
        
        return url.host ?? ""
    }
}
