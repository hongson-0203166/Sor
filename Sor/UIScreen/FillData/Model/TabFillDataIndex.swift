//
//  TabFillDataIndex.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//
import SwiftUI

struct FillDataParam {
  var textInput: Binding<String>
  var currentAge : Binding<Int>
  var items: Binding<[Int]>
}

enum TabFillDataIndex: CaseIterable {
  case fill1, fill2, fill3, fill4
  
  @ViewBuilder
  func view(_ parameters: FillDataParam) -> some View {
    switch self {
    case .fill1:
      FillData1View(textInput: parameters.textInput)
    case .fill2:
      FillData2View(currentAge: parameters.currentAge, items: parameters.items)
    case .fill3:
      FillData3View()
    case .fill4:
      FillData4View()
    }
  }
  
  var title: String {
    switch self {
    case .fill1:
      "What’s your name?"
    case .fill2:
      "Your age?"
    case .fill3:
      "Your weight?"
    case .fill4:
      "Your height?"
    }
  }
}
