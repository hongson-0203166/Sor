//
//  CustomPageControl.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/11/24.
//

import SwiftUI

struct CustomPageControl: View {
  let totalIndex: Int
  let selectedIndex: Int
  
  @Namespace private var animation
  
  var body: some View {
    HStack {
      ForEach(0..<totalIndex, id: \.self) { index in
        if selectedIndex == index {
          Rectangle()
            .fill(Color(hex: "#E83E56", alpha: 0.2))
            .frame(height: 5)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay {
              Rectangle()
                .fill(Color(hex: "#E83E56"))
                .frame(height: 5)
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .matchedGeometryEffect(id: "IndicatorAnimationId", in: animation)
            }
        } else {
          Rectangle()
            .fill(Color(hex: "#E83E56", alpha: 0.2))
            .frame(height: 5)
            .clipShape(RoundedRectangle(cornerRadius: 3))
        }
      }
    }
    .animation(.spring(), value: selectedIndex)
  }
}
