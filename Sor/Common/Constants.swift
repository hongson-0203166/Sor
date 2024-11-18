//
//  Constants.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias StringBlock = (String) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DynamicBlock<I,O> = ((I) -> O)

let WIDTH_SCREEN = UIScreen.main.bounds.width
let HEIGHT_SCREEN = UIScreen.main.bounds.height
let STATUS_BAR_HEIGHT = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
let NAVIGATION_HEIGHT = STATUS_BAR_HEIGHT + 44
let SAFE_BOTTOM_HEIGHT = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
let SAFE_TOP_HEIGHT = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
