//
//  BinaryFloatingPoint.swift
//  HeartCare
//
//  Created by Admin on 8/7/24.
//

import UIKit

extension BinaryFloatingPoint {
    func inverseLerp(min: Self, max: Self) -> Self {
        return (self - min) / (max - min)
    }
    
    func lerp(min: Self, max: Self) -> Self {
        return (max - min) * self + min
    }
    
    func colorLerp(minColor: UIColor, maxColor: UIColor) -> UIColor {
        let clampedValue = CGFloat(self.clamp(lowerBound: 0.0, upperBound: 1.0))
        let zero = CGFloat(0.0)
        
        
        var (r0, g0, b0, a0) = (zero, zero, zero, zero)
        minColor.getRed(&r0, green: &g0, blue: &b0, alpha: &a0)
        
        var (r1, g1, b1, a1) = (zero, zero, zero, zero)
        maxColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        return UIColor(red: clampedValue.lerp(min: r0, max: r1),
                       green: clampedValue.lerp(min: g0, max: g1),
                       blue: clampedValue.lerp(min: b0, max: b1),
                       alpha: clampedValue.lerp(min: a0, max: a1))
    }
}
