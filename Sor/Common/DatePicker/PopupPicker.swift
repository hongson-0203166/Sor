//
//  PopupPicker.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 28/11/24.
//

import SwiftUI
import MijickPopupView

struct CenterPopupDatePickerView: CentrePopup {
    
    @Binding var selection: Date?
    @State private var defaultSelection: Date = Date()
    @State private var datePicker = UIDatePicker(frame: .zero)
    @State private var datepickerSize: CGSize = .zero
    
    let minimumDate: Date?
    let maximumDate: Date?
    
    init(selectedDate: Binding<Date?>, minimumDate: Date?, maximumDate: Date?) {
        self._selection = selectedDate
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        if let defaultSelection = selectedDate.wrappedValue {
            self.defaultSelection = defaultSelection
        }
    }

    func configurePopup(popup: BottomPopupConfig) -> BottomPopupConfig {
        popup
    }
    
    func createContent() -> some View {
        VStack(spacing: 0) {
            ScalingDatePicker(selection: $defaultSelection, minimumDate: minimumDate, maximumDate: maximumDate)
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color(red: 0.49, green: 0.49, blue: 0.49))
                })
                .buttonStyle(.scaleEffect)
                .frame(maxWidth: .infinity)
                .frame(height: 41)
                .cornerRadius(27)
                .overlay(
                    RoundedRectangle(cornerRadius: 27)
                        .inset(by: 0.50)
                        .stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 0.50)
                )
                Button(action: {
//                    selection = datePicker.date
                    selection = defaultSelection
                    dismiss()
                }, label: {
                    Text("Save")
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity)
                .frame(height: 41)
                .background(Color(red: 0.91, green: 0.24, blue: 0.34))
                .cornerRadius(27)
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 36)
        }
    }
}

public struct ScalingDatePicker: View {
    
    @Binding var selection: Date
    @State var datepickerSize: CGSize = .zero
    let displayComponents: DatePicker.Components = [.hourAndMinute, .date]
    
    @State private var isLoading = true
    
    let minimumDate: Date?
    let maximumDate: Date?
    
    let minDate = Date(timeIntervalSinceReferenceDate: 0)
    
    public init(selection: Binding<Date>, minimumDate: Date? = nil, maximumDate: Date? = nil) {
        self._selection = selection
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // Hidden DatePicker to grab the Size for calculations
            DatePicker("", selection: $selection, displayedComponents: displayComponents)
                .datePickerStyle(.graphical)
                .pickerStyle(.inline)
                .scaleEffect()
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            datepickerSize = geo.size
                        }
                    }
                )
                .allowsHitTesting(false)
                .opacity(0)
            
            GeometryReader { geo in
                if let maximumDate = maximumDate {
                    DatePicker("", selection: $selection,in: ((minimumDate ?? minDate)...maximumDate),  displayedComponents: displayComponents)
                        .datePickerStyle(.graphical)
                        .pickerStyle(.inline)
                        .scaleEffect(
                            x: geo.size.width/datepickerSize.width,
                            anchor: .topLeading
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(isLoading ? 0 : 1)
                        .accentColor(Color(red: 0.91, green: 0.24, blue: 0.34))
                } else {
                    DatePicker("", selection: $selection, displayedComponents: displayComponents)
                        .datePickerStyle(.graphical)
                        .pickerStyle(.inline)
                        .scaleEffect(
                            x: geo.size.width/datepickerSize.width,
                            anchor: .topLeading
                        )
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(isLoading ? 0 : 1)
                        .accentColor(Color(red: 0.91, green: 0.24, blue: 0.34))
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .onAppear {
            let currentDate = selection
            selection = Date().addingTimeInterval(86400) // Tomorrow // update UI
            delay(second: 0.1) {
                selection = currentDate
                isLoading = false
            }
        }
    }
}

public extension ButtonStyle where Self == ScaleEffectButtonStyle {
  
  static var scaleEffect: Self { ScaleEffectButtonStyle() }
}

// MARK: - ScaleEffectButtonStyle
public struct ScaleEffectButtonStyle: ButtonStyle {
  
  public func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
  }
}

// MARK: - BackgroundButtonStyle
public struct BackgroundButtonStyle<Background: View>: ButtonStyle {
  private var background: Background

  public init(_ background: () -> Background) {
    self.background = background()
  }

  public func makeBody(configuration: Self.Configuration) -> some View {
    configuration
      .label
      .padding(.vertical)
      .frame(maxWidth: .infinity, alignment: .center)
      .background(background)
      .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
  }
}
