//
//  NSMutableAttributedString.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 16 }
    var boldFont:UIFont { return  UIFont.boldSystemFont(ofSize: fontSize) }
    var semiboldFont:UIFont { return  UIFont.systemFont(ofSize: fontSize) }
    var normalFont:UIFont { return  UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value: String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func customFont(_ value:String, font: UIFont? = nil) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font ?? UIFont.systemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func setColor(_ color: UIColor?, range: String) -> NSMutableAttributedString {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color as Any], range: (self.string as NSString).range(of: range))
        return self
    }
    
    func setColor(_ color: UIColor?, range: NSRange) -> NSMutableAttributedString {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color as Any], range: range)
        return self
    }
    
    /* Other styling methods */
    
    func hyperLink(url: String, range: String) -> NSMutableAttributedString {
        self.addAttribute(.link, value: url, range: (self.string as NSString).range(of: range))
        return self
    }
    
    func lineSpacing(_ value: CGFloat, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = value
        style.alignment = alignment
        self.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined() -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key : Any] = [
            .underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    func underlined(range: String) -> NSMutableAttributedString {
        self.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (self.string as NSString).range(of: range))
        return self
    }
}
