//
//  FillData.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//

import SwiftUI
import Hooks
import MijickPopupView

struct FillDataView: HookView {
  @State private var selectedIndex = 0
  @State private var textInput: String = ""
  @State private var currentAge: Int = 0
  @State private var items = Array(12...55)
  @State private var startDate: Date?
  @StateObject private var userModel = RealmHelper<User>()
  
  var hookBody: some View {
      ZStack {
          Color(hex: "F2F6FF")
              .edgesIgnoringSafeArea(.vertical)
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
              + Text("/3")
                .font(.system(size: 16, weight: .medium))
            }
            Spacer()
              .frame(height: 53)
            Text(TabFillDataIndex.allCases[selectedIndex].title)
              .font(.system(size: 36, weight: .bold))
              .foregroundColor(Color(hex: "141053"))
              CustomTabView(selectedIndex: $selectedIndex, items: TabFillDataIndex.allCases, textInput: $textInput, currentAge: $currentAge, itemsList: $items, startDate: $startDate)
            CommonButton()
              .frame(height: 58)
              .padding(.horizontal, 24)
              .onTapGesture {
                  hideKeyboard()
                  saveUser()
                  if selectedIndex == TabFillDataIndex.allCases.count - 1 {
                      UserDefaults.standard.isOnboarding = true
                      VCService.dismiss()
                  }
                  guard selectedIndex != TabFillDataIndex.allCases.count - 1 else { return }
                  selectedIndex += 1
              }
            Spacer()
              .frame(height: 50)
          }
      }
    .navigationBarHidden(true)
    .implementPopupView { config in
        config.top { $0
            .cornerRadius(24)
            .dragGestureEnabled(true)
        }
        .centre { $0
            .tapOutsideToDismiss(false)
        }
        .bottom { $0
            .stackLimit(4)
            .distanceFromKeyboard(0)
            .dragGestureEnabled(false)
            .tapOutsideToDismiss(true)
        }
    }
  }
    
    private func saveUser() {
        let newUser = User()
        newUser.name = textInput
        newUser.age = currentAge + 12
        newUser.cycleLatest = startDate ?? Date()
        newUser.cycleLength = 28
        newUser.periodLength = 5
        
        userModel.insertOrUpdate(newUser)
    }
}

struct CustomTabView: View {
    @Binding var selectedIndex: Int
    var items: [TabFillDataIndex]
    @Binding var textInput: String
    @Binding var currentAge: Int
    @Binding var itemsList: [Int]
    @Binding var startDate: Date?
    
    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) { index in
                if index == selectedIndex {
                    let params = FillDataParam(
                        textInput: $textInput,
                        currentAge: $currentAge,
                        items: $itemsList,
                        startDate: $startDate
                    )
                    items[index].view(params)
                        .transition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GeometryReader { _ in Color.clear }) // Block swipe gesture
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
