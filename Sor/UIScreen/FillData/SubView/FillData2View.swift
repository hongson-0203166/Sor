//
//  FillData1View.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//

import SwiftUI

struct FillData2View: View {
  @Binding var currentAge: Int
  @Binding var items: [Int]
  var body: some View {
      GeometryReader { geometry in
        VStack(alignment: .center, spacing: 0) {
          SwiftUIWheelPicker($currentAge, items: $items) { value in
            let isSelected = value == items[safe: currentAge]
            GeometryReader { reader in
              If(isSelected) {
                ZStack {
                  Color(red: 0.91, green: 0.24, blue: 0.34)
                  Text("\(value)")
                    .font(Font.custom("Outfit", size: 32).weight(.bold))
                    .foregroundColor(.white)
                }
                .frame(height: 95)
                .cornerRadius(24)
              } false: {
                ZStack {
                  Color.white
                  VStack(spacing: 10) {
                    Text("\(value)")
                      .font(Font.custom("Outfit", size: 20*130/92).weight(.bold))
                      .foregroundColor(Color(red: 0.91, green: 0.24, blue: 0.34).opacity(0.70))
                  }
                }
                .frame(height: 100)
                .cornerRadius(22)
                .overlay(
                  RoundedRectangle(cornerRadius: 22)
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.50)
                )
              }
            }
          }
          .width(.Ratio(0.3))
          .width(.Fixed(100))
          .scrollScale(0.7)
          .frame(width: geometry.size.width - 40, height: 100, alignment: .center)
          
          SwiftUIWheelPicker($currentAge, items: $items) { value in
            let isSelected = value == items[safe: currentAge]
            GeometryReader { reader in
              Capsule()
                .fill(isSelected ? Color.red : Color.red.opacity(0.16))
                .frame(width: isSelected ? 4 : 2, height: 60, alignment: .center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
            }
          }
          .scrollScale(1/3)
          .width(.VisibleCount(7))
          .frame(width: geometry.size.width - 40, height: 60, alignment: .center)
          .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
        }
    }
  }
  }


public struct SwiftUIWheelPicker<Content: View, Item>: View {
    
    private var items: Binding<[Item]>
    let contentBuilder: (Item) -> Content
    @Binding var position: Int
    @GestureState private var translation: CGFloat = 0
    private var contentWidthOption: WidthOption = .VisibleCount(5)
    private var sizeFactor: CGFloat = 1
    private var alphaFactor: Double = 1
    private var edgeLeftView: AnyView? = nil
    private var edgeLeftWidth: WidthOption? = nil
    private var edgeRightView: AnyView? = nil
    private var edgeRightWidth: WidthOption? = nil
    private var centerView: AnyView? = nil
    private var centerViewWidth: WidthOption? = nil
    private var isInfinite: Bool = false
    private var onValueChanged: ((Item) -> Void)? = nil
    
    public init(_ position: Binding<Int>, items: Binding<[Item]>, @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = items
        self._position = position
        self.contentBuilder = content
    }
    
    public init(_ position: Binding<Int>, items: [Item], @ViewBuilder content: @escaping (Item) -> Content) {
        self.items = Binding.constant(items)
        self._position = position
        self.contentBuilder = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                HStack(spacing: 0) {
                    ForEach(0..<items.wrappedValue.count, id: \.self) { position in
                        drawContentView(position, geometry: geometry)
                    }
//                    ForEach(0..<10001, id: \.self) { position in
//                        let position = position%items.wrappedValue.count
//                        drawContentView(position, geometry: geometry)
//                    }
//                    ForEach(items.wrappedValue.indices) { position in
//                        drawContentView(position, geometry: geometry)
//                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.position + 1) * self.calcContentWidth(geometry, option: contentWidthOption))
                .offset(x: self.translation + (geometry.size.width / 2) + (self.calcContentWidth(geometry, option: contentWidthOption) / 2))
                .animation(.interactiveSpring(), value: self.position + 1)
                .animation(.interactiveSpring(), value: translation)
                .clipped()
                if let view = edgeLeftView, let width = edgeLeftWidth {
                    view.frame(width: calcContentWidth(geometry, option: width), height: geometry.size.height, alignment: .center)
                }
                if let view = edgeRightView, let widthOption = edgeRightWidth {
                    let width = calcContentWidth(geometry, option: widthOption)
                    view
                        .offset(x: geometry.size.width - width)
                        .frame(width: width, height: geometry.size.height, alignment: .center)
                }
                if let view = centerView, let widthOption = centerViewWidth {
                    let width = calcContentWidth(geometry, option: widthOption)
                    view
                        .offset(x: geometry.size.width / 2 - width / 2)
                        .frame(width: width, height: geometry.size.height, alignment: .center)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }
                .onEnded { value in
                    let offset = value.translation.width / self.calcContentWidth(geometry, option: contentWidthOption)
                    let newIndex = (CGFloat(self.position) - offset).rounded()
                    self.position = min(max(Int(newIndex), 0), self.items.wrappedValue.count - 1)
                    self.onValueChanged?(items.wrappedValue[self.position])
                }
            )
        }
    }
    
    public func width(_ option: WidthOption) -> Self {
        var newSelf = self
        newSelf.contentWidthOption = option
        return newSelf
    }
    
    public func scrollAlpha(_ value: Double) -> Self {
        var newSelf = self
        newSelf.alphaFactor = value
        return newSelf
    }
    
    public func scrollScale(_ value: CGFloat) -> Self {
        var newSelf = self
        newSelf.sizeFactor = value
        return newSelf
    }
    
    public func edgeLeft(_ view: AnyView, width: WidthOption) -> Self {
        var newSelf = self
        newSelf.edgeLeftView = view
        newSelf.edgeLeftWidth = width
        return newSelf
    }
    
    public func edgeRight(_ view: AnyView, width: WidthOption) -> Self {
        var newSelf = self
        newSelf.edgeRightView = view
        newSelf.edgeRightWidth = width
        return newSelf
    }
    
    public func centerView(_ view: AnyView, width: WidthOption) -> Self {
        var newSelf = self
        newSelf.centerView = view
        newSelf.centerViewWidth = width
        return newSelf
    }
    
    public func infiniteScroll(_ value: Bool) -> Self {
        var newSelf = self
        newSelf.isInfinite = value
        return newSelf
    }
    
    public func onValueChanged(_ callback: @escaping (Item) -> Void) -> Self {
        var newSelf = self
        newSelf.onValueChanged = callback
        return newSelf
    }
    
    private func drawContentView(_ position: Int, geometry: GeometryProxy) -> some View {
        var sizeResult: CGFloat = 1
        var alphaResult: Double = 1
        
        if sizeFactor != 1.0 || alphaFactor != 1.0 {
            let maxRange = floor(maxVisible(geometry) / 2.0)
            let offset = translation / self.calcContentWidth(geometry, option: contentWidthOption)
            let newIndex = CGFloat(self.position) - offset
            let posGap = CGFloat(position) - newIndex
            //let posGap = CGFloat(position) - (newIndex.truncatingRemainder(dividingBy: CGFloat(self.items.wrappedValue.count)))
            var per = abs(posGap / maxRange)
            if 1.0 < per {
                per = 1.0
            }
            
            if sizeFactor != 1.0 {
                let sizeGap = 1.0 - sizeFactor
                let preSizeRst = per * sizeGap
                sizeResult = max(1 - preSizeRst, 0.7)
            }
            
            if alphaFactor != 1.0 {
                let alphaGap = 1.0 - alphaFactor
                let preAlphaRst = Double(per) * alphaGap
                alphaResult = 1.0 - preAlphaRst
            }
        }
        
        let item = items.wrappedValue[position]
        return contentBuilder(item)
            .scaleEffect(sizeResult)
            .opacity(alphaResult)
            .frame(width: self.calcContentWidth(geometry, option: contentWidthOption), alignment: .center)
    }
    
    private func maxVisible(_ geometry: GeometryProxy) -> CGFloat {
        let visibleCount = geometry.size.width / self.calcContentWidth(geometry, option: contentWidthOption)
        return min(visibleCount, CGFloat(self.items.wrappedValue.count))
    }
    
    private func calcContentWidth(_ geometry: GeometryProxy, option: WidthOption) -> CGFloat {
        switch option {
        case .VisibleCount(let count):
            return geometry.size.width / CGFloat(count)
        case .Fixed(let width):
            return width
        case .Ratio(let ratio):
            return geometry.size.width * ratio
        }
    }
}
public enum WidthOption {
    case VisibleCount(Int)
    case Fixed(CGFloat)
    case Ratio(CGFloat)
}

public struct If<TrueContent: View, FalseContent: View>: View {
  
  var value: Bool
  let trueContent: () -> TrueContent
  let falseContent: () -> FalseContent
  
  init(
    _ value: Bool,
    @ViewBuilder `true`: @escaping () -> TrueContent,
    @ViewBuilder `false`: @escaping () -> FalseContent
  ) {
    self.value = value
    self.trueContent = `true`
    self.falseContent = `false`
  }
  
  init(
    _ value: Bool,
    @ViewBuilder `true`: @escaping () -> TrueContent
  ) where FalseContent == EmptyView {
    self.init(value, true: `true`) {
      EmptyView()
    }
  }
  
  @ViewBuilder
  public var body: some View {
    if value {
      trueContent()
    } else {
      falseContent()
    }
  }
}
private extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
