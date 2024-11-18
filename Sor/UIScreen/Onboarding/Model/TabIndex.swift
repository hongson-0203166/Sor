//
//  TabIndex.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/11/24.
//
import SwiftUI

enum TabOnbIndex: CaseIterable {
  case onb1, onb2, onb3, onb4
  
  @ViewBuilder
  var view: some View {
      switch self {
      case .onb1:
          Onboarding1View()
      case .onb2:
          Onboarding2View()
      case .onb3:
          Onboarding3View()
      case .onb4:
          Onboarding4View()
      }
  }
}
