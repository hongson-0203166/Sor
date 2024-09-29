//
//  Common.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

enum Common {
  
  static func showWebLink(_ link: String) {
    if let url = NSURL(string: link) {
      UIApplication.shared.open(url as URL)
    }
  }
}
