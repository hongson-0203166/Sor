//
//  FillData3View.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 28/11/24.
//

import SwiftUI

import SwiftUI
import MijickPopupView

struct FillData3View: View {
    @Binding var selectedDate: Date?
    @State var cycleLength: Int = 28
    @State var periodLength: Int = 5
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Color(red: 222, green: 225, blue: 231)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)
                HStack {
                    Text(selectedDate?.toStringMedium() ?? "Start Date")
                        .if(selectedDate == nil, transform: { text in
                            text.font(.system(size: 16))
                                .foregroundColor(Color(red: 0.61, green: 0.64, blue: 0.69))
                        }, else: { text in
                            text.font(.system(size: 14))
                                .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.15))
                        })
                        .padding(.leading, 20)
                        .frame(height: 48)
                    
                    Spacer()
                    Image(.icDateRangeLight)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .padding(.trailing, 12)
                }
                .background(
                    If(selectedDate != nil) {
                        Color(red: 222, green: 225, blue: 231)
                    } false: {
                        Color(red: 222, green: 225, blue: 231)
                            .overlay(
                              RoundedRectangle(cornerRadius: 5)
                                .inset(by: 0.50)
                                .stroke(Color(red: 0.84, green: 0.22, blue: 0.26), lineWidth: 0.50)
                            )
                    }
                        .frame(height: 48)
                        .cornerRadius(6)
                )
            }
            .padding(.horizontal, 36)
            .frame(height: 48)
            .contentShape(.rect)
            .onTapGesture {
                CenterPopupDatePickerView(selectedDate: $selectedDate, minimumDate: nil, maximumDate: Date()).showAndStack()
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}


public extension View {
  func debugFrame() -> some View {
    return modifier(PreviewFrameViewModifier())
  }
}

public struct PreviewFrameViewModifier: ViewModifier {
  
  @State private var isPresentedBackground: Bool = false
  
  public func body(content: Content) -> some View {
#if !DEBUG
    return content
#endif
    content
      .overlay(
        GeometryReader { geometry in
          let globalOrigin: CGPoint = geometry.frame(in: .global).origin
          let origin: String = "(x: \(rounded(globalOrigin.x)), y: \(rounded(globalOrigin.y)))"
          let size: String = "(w: \(rounded(geometry.size.width)), h: \(rounded(geometry.size.height)))"
          ZStack(alignment: .bottom) {
            if isPresentedBackground {
#if iOS
              Color(.systemBackground)
#endif
            }
            Rectangle()
              .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
              .foregroundColor(Color.red)
            Text("\(origin) | \(size)")
              .fontWeight(.bold)
              .foregroundColor(Color.red)
#if iOS
              .font(.caption2)
#endif
              .zIndex(9999)
              .onTapGesture {
                isPresentedBackground.toggle()
              }
          }
        }
      )
  }
  
  private func rounded(_ value: CGFloat) -> Float {
    return Float(round(100 * value) / 100)
  }
}
