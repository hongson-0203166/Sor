//
//  Untitled.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 21/11/24.
//

import UIKit
import SwiftUI

open class DoublePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    public var onChanged: (([Int]) -> Void)?
    public var onChangedInComponent: ((Int) -> Void)?
    
    public var data: [[String]] = [] {
        didSet {
            update()
            selections = Array(repeating: 0, count: data.count)
            onChanged?(selections)
        }
    }
    
    var selections: [Int] = []
    
    public var selectionValues: [String?] {
        var items: [String?] = []
        for index in 0..<selections.count {
            items.append(data[index][selections[index]])
        }
        return items
    }
    
    open var rowHeight: CGFloat {
        48
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    public func update() {
        pickerView.reloadAllComponents()
        layoutSubviews()
    }
    
    open func updateCurrentIndex(_ values: [Int]) {
        self.selections = values
        for value in 0..<values.count {
                pickerView.selectRow(values[value], inComponent: value, animated: true)
        }
        self.onChanged?(self.selections)
        self.update()
    }
    
    open func updateCurrentValue(_ values: [String]) {
        var idx: [Int] = []
        for value in 0..<values.count {
            if let item = data[value].firstIndex(where: {$0 == values[value]}) {
                pickerView.selectRow(item, inComponent: value, animated: true)
                idx.append(item)
            } else {
                idx.append(0)
            }
        }
        updateCurrentIndex(idx)
    }

    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for subview in pickerView.subviews {
            // Thay đổi vùng highlight trong picker view
            if subview.className.contains("_UIPickerHighlightView") || (subview.className.contains("UIView") && subview.subviews.isEmpty) {
                subview.frame.origin.x = 0
                subview.frame.size.width = self.frame.width
                subview.backgroundColor = UIColor(hex: 0x747480)
                subview.backgroundColor = UIColor(Color.init("747480").opacity(0.08))

            } else {
                // Bring các view nội dung lên trên highlight
                pickerView.bringSubviewToFront(subview)
            }
        }
    }
    
    open func setupViews() {
        backgroundColor = .clear
        pickerView.backgroundColor = .clear
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func changingPicker(_ picker: (UIPickerView) -> ()) -> Self {
        picker(pickerView)
        return self
    }
    
// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfRowsInComponent = data[component].count
        return numberOfRowsInComponent
    }
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        Text(data[component][row])
            .if(row == selections[component]) {
                $0.font(Font.custom("Outfit", size: 28).weight(.medium))
                    .foregroundColor(Color(red: 0.07, green: 0.09, blue: 0.28))
            } else: {
                $0.font(Font.custom("Outfit", size: 26))
                    .foregroundColor(Color(red: 0.42, green: 0.45, blue: 0.50))
            }
            .toUIView()
    }
    
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        rowHeight
    }
    
    open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        pickerView.frame.size.width/CGFloat(data.count + 1)
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selections[component] = row
        onChanged?(selections)
        onChangedInComponent?(component)
        update()
    }
}
