//
//  CommonButton.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//

import SwiftUI

struct CommonButton: View {
  @State var backgroundColor: Color = Color(hex: "#E83E56")
  @State var title: String = "Continue"
  
  var body: some View {
    ZStack {
      backgroundColor
        .clipShape(Capsule())
      
      Text(title)
        .font(.headline)
        .foregroundColor(.white)
    }
  }
}

