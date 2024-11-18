//
//  Comparable.swift
//  HeartCare
//
//  Created by Admin on 8/7/24.
//

import Foundation

extension Comparable {
    func clamp(lowerBound: Self, upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}
