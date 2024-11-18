

import UIKit

extension Array where Element == UIColor {
    // Make sure every color in colors array is in RGB color space
    var rgbNormalized: [UIColor] {
        return map { color in
            guard color.cgColor.numberOfComponents == 2 else {
                return color
            }
            
            let white: CGFloat = color.cgColor.components![0]
            return UIColor(red: white, green: white, blue: white, alpha: 1.0)
        }
    }
    
    var componentsJoined: [CGFloat] {
        return flatMap { $0.cgColor.components ?? [] }
    }
}
