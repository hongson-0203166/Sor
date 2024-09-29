//
//  Extension+String.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 11/09/2024.
//

import UIKit

extension String {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }

    var length: Int {
        return self.count
    }
}

extension UILabel {
  func addInterlineSpacing(spacingValue: CGFloat = 2, alignment: NSTextAlignment = .left) {
      
      // MARK: - Check if there's any text
      guard let textString = text else { return }
      
      // MARK: - Create "NSMutableAttributedString" with your text
      let attributedString = NSMutableAttributedString(string: textString)
      
      // MARK: - Create instance of "NSMutableParagraphStyle"
      let paragraphStyle = NSMutableParagraphStyle()
      
      // MARK: - Actually adding spacing we need to ParagraphStyle
      paragraphStyle.lineSpacing = spacingValue
      paragraphStyle.alignment = alignment
      
      // MARK: - Adding ParagraphStyle to your attributed String
      attributedString.addAttribute(
          .paragraphStyle,
          value: paragraphStyle,
          range: NSRange(location: 0, length: attributedString.length)
      )
      
      attributedText = attributedString
  }
}
