

import UIKit

extension Int {
    func rewriteDateTime() -> String {
        if self < 10 {
            return "0\(self)"
        }
        return "\(self)"
    }
    
    func toDuration() -> String {
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        
        if self >= 3600 {
            hours = self / 3600
            minutes = (self - (hours * 3600)) / 60
            if minutes > 0 {
                seconds = (self - (hours * 3600)) - (minutes * 60)
            } else {
                seconds = self - (hours * 3600)
            }
        } else if self >= 60 {
            minutes = self / 60
            seconds = self - (minutes * 60)
        } else {
            seconds = self
        }
        
        if hours == 0 {
            return "\(minutes.rewriteDateTime()):\(seconds.rewriteDateTime())"
        }
        
        return "\(hours.rewriteDateTime()):\(minutes.rewriteDateTime()):\(seconds.rewriteDateTime())"
    }
    
    func toPages(perPage: Int) -> Int {
        if self == 0 { return self }
        
        if self < perPage && self != 0 {
            return 1
        } else {
            if self % perPage == 0 {
                return self / perPage
            } else {
                return (self / perPage) + 1
            }
        }
    }
    
    func returnMonth() -> Int {
        var number = self
        if self > 12 {
            number = self - 12
        }
        return number
    }
}

extension Int {
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    var toFloat: Float {
        return Float(self)
    }
}

extension Int {
    var toString: String {
        return "\(self)"
    }
}

extension Double {
    var toString: String {
        return "\(self)"
    }
}

extension CGFloat {
    var toString: String {
        return "\(self)"
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func toStringDecimal(_ fractionDigits: Int, showZero: Bool = false) -> String {
        let decimal = roundToDecimal(fractionDigits)
        if !showZero && (decimal - Int(decimal).toCGFloat == 0) {
            return Int(decimal).toString
        } else {
            return decimal.toString
        }
    }
}

extension Float {
    var toInt: Int {
        return Int(self)
    }
    
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    var toString: String {
        return "\(self)"
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Float {
        let multiplier = pow(10, fractionDigits.toFloat)
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func toStringDecimal(_ fractionDigits: Int, showZero: Bool = false) -> String {
        let decimal = roundToDecimal(fractionDigits)
        if !showZero && (decimal - Int(decimal).toFloat == 0) {
            return Int(decimal).toString
        } else {
            return decimal.toString
        }
    }
}
