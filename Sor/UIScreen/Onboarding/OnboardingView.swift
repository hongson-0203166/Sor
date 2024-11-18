//
//  Onboarding.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 11/11/24.
//

import SwiftUI
import Hooks

struct OnboardingView: HookView {
    @State private var selectedIndex = 0
    
    var hookBody: some View {
      let timer = TimerS.useTimer(interval: 5)
      NavigationView {
        ZStack(alignment: .bottom) {
          TabView(selection: $selectedIndex) {
            ForEach(0..<TabOnbIndex.allCases.count, id: \.self) { index in
              TabOnbIndex.allCases[index].view
                .tag(index)
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
          .onChange(of: timer) {
            withAnimation {
              guard selectedIndex != TabOnbIndex.allCases.count - 1 else { return }
              selectedIndex = (selectedIndex + 1) % TabOnbIndex.allCases.count
            }
          }
          
          // Custom Page Control
          CustomPageControl(
            totalIndex: TabOnbIndex.allCases.count,
            selectedIndex: selectedIndex
          )
          .padding(.horizontal, 127)
        }
      }
    }
}
