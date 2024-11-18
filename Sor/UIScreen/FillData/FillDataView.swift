//
//  FillData.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//

import SwiftUI
import Hooks

struct FillDataView: HookView {
  @State private var selectedIndex = 0
  @State private var textInput: String = ""
  @State private var currentAge: Int = 29
  @State private var items = Array(1...110)
  
  var hookBody: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Image(R.image.ic_back)
          .resizable()
          .scaledToFit()
          .frame(width: 48, height: 48)
          .onTapGesture {
            withAnimation {
              guard selectedIndex != 0 else { return }
              selectedIndex -= 1
            }
          }
          .hidden(selectedIndex == 0)
        Spacer()
      }
      .padding(.horizontal, 24)
      .overlay {
        Text("\(selectedIndex + 1)")
          .foregroundColor(Color(hex: "E83E56"))
          .font(.system(size: 30, weight: .medium))
        + Text("/4")
          .font(.system(size: 16, weight: .medium))
      }
      Spacer()
        .frame(height: 53)
      Text(TabFillDataIndex.allCases[selectedIndex].title)
        .font(.system(size: 36, weight: .bold))
        .foregroundColor(Color(hex: "141053"))
      TabView(selection: $selectedIndex) {
        ForEach(0..<TabFillDataIndex.allCases.count, id: \.self) { index in
          let params = FillDataParam(textInput: $textInput, currentAge: $currentAge, items: $items)
          TabFillDataIndex.allCases[index].view(params)
            .tag(index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      
      CommonButton()
        .frame(height: 58)
        .padding(.horizontal, 24)
        .onTapGesture {
          withAnimation {
            guard selectedIndex != TabFillDataIndex.allCases.count - 1 else { return }
            selectedIndex += 1
          }
        }
      Spacer()
        .frame(height: 50)
    }
    .navigationBarHidden(true)
  }
}

struct HideViewModifier: ViewModifier {
    let isHidden: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isHidden ? 0 : 1)
    }
}

// Extending on View to apply to all Views
extension View {
    func hidden(_ isHidden: Bool) -> some View {
        self.modifier(HideViewModifier(isHidden: isHidden))
    }
}
