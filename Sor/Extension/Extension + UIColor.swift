//
//  Extension + UIColor.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit
import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17), (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (UInt64(alpha * 255), int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (UInt64(alpha * 255), 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension DateFormatter {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIColor {
  
  convenience init(hex: String) {
    let r, g, b, a: CGFloat
    
    // Remove the hash if it exists
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexString = hexString.replacingOccurrences(of: "#", with: "")
    
    // Ensure the hex string is 6 or 8 characters long
    if hexString.count == 6 {
      hexString += "FF" // Default alpha value if none provided
    }
    
    if hexString.count == 8 {
      let start = hexString.startIndex
      let rIndex = hexString.index(start, offsetBy: 2)
      let gIndex = hexString.index(start, offsetBy: 4)
      let bIndex = hexString.index(start, offsetBy: 6)
      let aIndex = hexString.index(start, offsetBy: 8)
      
      let rString = String(hexString[start..<rIndex])
      let gString = String(hexString[rIndex..<gIndex])
      let bString = String(hexString[gIndex..<bIndex])
      let aString = String(hexString[bIndex..<aIndex])
      
      var rValue: UInt64 = 0
      var gValue: UInt64 = 0
      var bValue: UInt64 = 0
      var aValue: UInt64 = 0
      
      Scanner(string: rString).scanHexInt64(&rValue)
      Scanner(string: gString).scanHexInt64(&gValue)
      Scanner(string: bString).scanHexInt64(&bValue)
      Scanner(string: aString).scanHexInt64(&aValue)
      
      r = CGFloat(rValue) / 255.0
      g = CGFloat(gValue) / 255.0
      b = CGFloat(bValue) / 255.0
      a = CGFloat(aValue) / 255.0
      
    } else {
      r = 1.0
      g = 1.0
      b = 1.0
      a = 1.0
    }
    
    self.init(red: r, green: g, blue: b, alpha: a)
  }
}


extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}


extension UIView {
  func addShadow(color: UIColor = UIColor.black.withAlphaComponent(0.07), radius: CGFloat = 1, offset: CGSize = .init(width: 1, height: 1)) {
    self.layer.shadowColor = color.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = radius
    layer.shadowOffset = offset
  }
}


import UIKit

// MARK: - UICollectionReusableView (Header & Footer)
enum XibCollectionSupplementaryKind {
    case header, footer
    
    var kind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: type.name)
    }
    
    func registerNibSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: XibCollectionSupplementaryKind) {
        let nibName = type.name
        register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: nibName)
    }
    
    // MARK: - Get component functions
    func dequeueCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
    
    func reusableCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T? {
        let nibName = type.name
        return self.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    func reusableSupplementaryViewFor<T: UIView>(type: T.Type, ofKind kind: XibCollectionSupplementaryKind, indexPath: IndexPath) -> T? {
        let nibName = type.name
        return self.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: nibName, for: indexPath) as? T
    }
    
    func cell<T: UICollectionViewCell>(type: T.Type, section: Int, item: Int) -> T? {
        guard let indexPath = validIndexPath(section: section, item: item) else { return nil }
        return self.cellForItem(at: indexPath) as? T
    }
    
    // MARK: - Supporting functions
    func validIndexPath(section: Int, item: Int) -> IndexPath? {
        guard section >= 0 && item >= 0 else { return nil }
        let itemCount = numberOfItems(inSection: section)
        guard itemCount > 0 && item < itemCount else { return nil }
        return IndexPath(item: item, section: section)
    }
}

// MARK: Methods
extension UICollectionViewCell {
    static var cellName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    static var nibName: String {
        return cellName
    }
    
    static var reuseIdentifier: String {
        return cellName
    }
}


import UIKit

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

extension UIView {
    var name: String {
        return type(of: self).name
    }
    
    class func nib() -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed( name, owner: nil, options: nil)![0] as! T
    }
}

extension UIView {
    func setBorder(width: CGFloat, color: UIColor?, radius: CGFloat = 0) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
        self.layer.cornerRadius = radius
    }
    
    func setBackgroundColor(color: UIColor) {
        self.layer.backgroundColor = color.cgColor
    }
    
    func constraintToAllSides(of container: UIView, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: topOffset),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leftOffset),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: rightOffset),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomOffset)
        ])
    }
    
    func hidenView(_ isHidden: Bool,
                   with inView: UIView? = nil,
                   time: TimeInterval = 0.35,
                   completion: (() -> Void)? = nil) {
        UIView.transition(with: inView != nil ? inView! : self,
                          duration: time,
                          options: [UIView.AnimationOptions.transitionCrossDissolve],
                          animations: {
            self.isHidden = isHidden
        },
                          completion: { _ in
            completion?()
        })
    }
}

extension UIView {
    @IBInspectable var mborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var mborderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var halfRadius: Bool {
        get {
            setNeedsDisplay()
            return layer.cornerRadius == frame.size.height/2
        }
        
        set {
            if newValue {
                clipsToBounds = true
                layer.cornerRadius = frame.size.height/2
                setNeedsDisplay()
            } else {
                layer.cornerRadius = cornorRadius
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var cornorRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            if halfRadius {
                return
            } else {
                layer.cornerRadius = newValue
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
            layer.setNeedsDisplay()
        }
        get {
            return layer.shadowRadius
        }
    }
}

extension UIView {
    
    // Hide a view with default animation
    func hide(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        // allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || self.isHidden {
                self.isHidden = true
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { (success) in
                self.isHidden = true
                self.alpha = currentAlpha
                completion?()
            })
        }
    }
    
    //Show a view with animation
    func show(animation: Bool = true, duration: TimeInterval = 0.3, completion: (() -> ())? = nil) {
        
        //allway update UI on mainthread
        DispatchQueue.main.async {
            
            if !animation || !self.isHidden {
                self.isHidden = false
                completion?()
                return
            }
            
            let currentAlpha = self.alpha
            self.alpha = 0.05
            self.isHidden = false
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = currentAlpha
            }, completion: { (success) in
                completion?()
            })
        }
    }
    
    func fitParent(padding: UIEdgeInsets = .zero) {
        
        guard let parent = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leftAnchor.constraint(equalTo: parent.leftAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            self.rightAnchor.constraint(equalTo: parent.rightAnchor)
        ])
    }
    
    //rotate view 3D with Z
    func rotate(duration: CFTimeInterval = 0.8, toValue: Any = Float.pi*2, repeatCount: Float = .infinity, removeOnCompleted: Bool = false) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = duration
        animation.toValue = toValue
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removeOnCompleted
        layer.add(animation, forKey: "rotate")
    }
    
    // Remove rotate animation
    func stopRotate() {
        layer.removeAnimation(forKey: "rotate")
    }
}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    enum BorderSide {
        case top
        case bottom
        case left
        case right
    }
    
    func addBorderToSide(_ side: BorderSide, color: UIColor?, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        
        switch side {
        case .top:
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .bottom:
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        case .right:
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        }
        
        addSubview(border)
    }
    
    var isViewEnabled: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set(value) {
            self.isUserInteractionEnabled = value
            self.alpha = value ? 1 : 0.4
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    enum GradientDirection {
        case left, topLeft, top, topRight, right, bottomRight, bottom, bottomLeft
        
        var point: CGPoint {
            switch self {
            case .left:
                return .init(x: 0, y: 0.5)
            case .topLeft:
                return .init(x: 0, y: 0)
            case .top:
                return .init(x: 0.5, y: 0)
            case .topRight:
                return .init(x: 1, y: 0)
            case .right:
                return .init(x: 1, y: 0.5)
            case .bottomRight:
                return .init(x: 1, y: 1)
            case .bottom:
                return .init(x: 0.5, y: 1)
            case .bottomLeft:
                return .init(x: 0, y: 1)
            }
        }
    }
    
    func gradient(startColor: UIColor = UIColor(hex: 0xE2465C), endColor: UIColor = UIColor(hex: 0xFFC370), cornerRadius: CGFloat = 0, startPoint: GradientDirection = .left, endPoint: GradientDirection = .right) {
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        layer.cornerRadius = cornerRadius
    }
    
    func gradientBorder(startColor: UIColor = UIColor(hex: 0xE2465C), endColor: UIColor = UIColor(hex: 0xFFC370), cornerRadius: CGFloat = 0, strokeWidth: CGFloat = 3, startPoint: GradientDirection = .left, endPoint: GradientDirection = .right) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        
        let shape = CAShapeLayer()
        shape.lineWidth = strokeWidth
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        layer.cornerRadius = cornerRadius
        layer.addSublayer(gradient)
    }
    
    func removeGradientInView() {
        self.layer.sublayers?.forEach({ layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    func removeUILabelInView() {
        subviews.forEach({ layer in
            if layer is UILabel {
                layer.removeFromSuperview()
            }
        })
    }
}


    
   

extension UIView {
    func toImage() -> UIImage {
        let imageRenderer = UIGraphicsImageRenderer(bounds: bounds)
        if let format = imageRenderer.format as? UIGraphicsImageRendererFormat {
            format.opaque = true
        }
        let image = imageRenderer.image { context in
            return layer.render(in: context.cgContext)
        }
        return image
    }
    
}

//MARK: - Convert Frame
extension UIView {
    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }
        
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        
        return superview!.convert(frame, to: self)
    }
}

extension UIView {

    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    var size: CGSize {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }

    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    var top : CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var bottom : CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }

    var right : CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }

    var left : CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x  = newValue
            self.frame = frame
        }
    }
}



extension UIView {
    enum RoundCornersAt {
        case topRight, topLeft, bottomRight, bottomLeft
        
        var maskedCorners: CACornerMask {
            switch self {
            case .topRight:
                return .layerMaxXMinYCorner
            case .topLeft:
                return .layerMinXMinYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            }
        }
    }
    
    func roundCorners(corners: [RoundCornersAt], radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(corners.map(\.maskedCorners))
    }
}

//MARK: - Constraint
extension UIView {
    @discardableResult
    func apply<T>(transform: ((T) -> Void)) -> Self {
        if let self = self as? T {
            transform(self)
        }
        return self
    }
    
    @discardableResult
    func attachTo(view: UIView) -> Self {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func setConstraint(with: UIView? = nil, leading: CGFloat? = nil, leadingToTrailing: CGFloat? = nil, top: CGFloat? = nil, topToBottom: CGFloat? = nil, trailing: CGFloat? = nil, trailingToLeading: CGFloat? = nil, bottom: CGFloat? = nil, bottomToTop: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        if let with = with {
            if let leading = leading {
                self.leadingAnchor.constraint(equalTo: with.leadingAnchor, constant: leading).isActive = true
            }
            if let leadingToTrailing = leadingToTrailing {
                self.leadingAnchor.constraint(equalTo: with.trailingAnchor, constant: leadingToTrailing).isActive = true
            }
            if let top = top {
                self.topAnchor.constraint(equalTo: with.topAnchor, constant: top).isActive = true
            }
            if let topToBottom = topToBottom {
                self.topAnchor.constraint(equalTo: with.bottomAnchor, constant: topToBottom).isActive = true
            }
            if let trailing = trailing {
                with.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailing).isActive = true
            }
            if let trailingToLeading = trailingToLeading {
                with.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingToLeading).isActive = true
            }
            if let bottom = bottom {
                with.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottom).isActive = true
            }
            if let bottomToTop = bottomToTop {
                with.topAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomToTop).isActive = true
            }
            if let centerX = centerX {
                self.centerXAnchor.constraint(equalTo: with.centerXAnchor, constant: centerX).isActive = true
            }
            if let centerY = centerY {
                self.centerYAnchor.constraint(equalTo: with.centerYAnchor, constant: centerY).isActive = true
            }
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return self
    }
    
    func fixInView(view: UIView) {
        self
            .attachTo(view: view)
            .setConstraint(with: view, leading: 0.0, top: 0.0, trailing: 0.0, bottom: 0.0)
    }
    
    func addBlurrEffect(intensity: Double = 1) {
        let blurEffectView = CustomBlurView() // creating a blur effect view
        blurEffectView.intensity = intensity // setting blur intensity from 0.1 to 10
        self.addSubview(blurEffectView) // adding blur effect view as a subview to your view in which you want to use
    }
}

class CustomBlurView: UIVisualEffectView {
    
    var animator = UIViewPropertyAnimator(duration: 1, curve: .linear)
    
    var intensity = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame = superview?.bounds ?? CGRect.zero
        setupBlur()
    }
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        backgroundColor = .clear
        setupBlur()
    }
    
    private func setupBlur() {
        animator.stopAnimation(true)
        effect = nil

        animator.addAnimations { [weak self] in
            self?.effect = UIBlurEffect(style: .regular)
        }
        
        if intensity > 0 && intensity <= 10 {
            
            let value = CGFloat(intensity)/10
            animator.fractionComplete = value
            
        }
        else {
            animator.fractionComplete = 0.05
        }
    }
    
    deinit {
        animator.stopAnimation(true)
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor?]) -> CAGradientLayer {
        return self.applyGradient(colours: colours.compactMap { $0 }, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]? =  [0.0, 1.0], vertical: Bool = true) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.name = "masklayer"
        gradient.startPoint = vertical ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0, y: 0.5)
        gradient.endPoint = vertical ? CGPoint(x: 0.5, y: 1) : CGPoint(x: 1, y: 0.5)
        gradient.frame = self.bounds
        self.layer.sublayers?.removeAll(where: { (layer) -> Bool in
            if let _ = layer as? CAGradientLayer, layer.name == "masklayer" {
                return true
            }
            return false
        })
        self.layer.insertSublayer(gradient, at:0)
        
        return gradient
    }
    
    func roundCorners(_ radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func roundCornersMask(_ cornerMask: CACornerMask, radius: CGFloat) {
        roundCorners(radius)
        layer.maskedCorners = cornerMask
    }
}



extension UIView {
    // ->1
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.4,
                                  direction: Direction = .leftToRight,
                                  repeatCount: Float = MAXFLOAT) {
        
        // Create color  ->2
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).cgColor
        let blackColor = UIColor.black.cgColor
        
        // Create a CAGradientLayer  ->3
        let gradientLayer = CAGradientLayer()
        // màu sắc gadient (trắng ở giữa)
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        // kích thước gadient
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.width, width: 3 * self.bounds.size.width, height: 4 * self.bounds.size.width)
        
        switch direction {
            case .topToBottom:
                // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ trên xuống dưới
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
            case .bottomToTop:
                // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ dưới lên trên
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                
            case .leftToRight:
                // điểm sáng nhất tập trung tại y = 0.5 và di chuyển từ trái sang phải
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
            case .rightToLeft:
                // điểm sáng nhất tập trung tại x = 0.5 và di chuyển từ phải sang trái
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                
            case .topLeftToBottomRight:
                // di chuyển từ (0.0,0.0) -> (1.0,1.0)
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                
            case .topRightToBottomLeft:
                // di chuyển từ (1.0,0.0) -> (0.0,1.0)
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                
            case .bottomLeftToTopRight:
                // di chuyển từ (0.0,1.0) -> (1.0,0.0)
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                
            case .bottomRightToTopLeft:
                // di chuyển từ (1.0,1.0) -> (0.0,0.0)
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
        // Một mảng tùy chọn của các đối tượng NSNumber xác định vị trí của mỗi điểm dừng gradient. animation
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        // Xác định giá trị mà máy thu sử dụng để bắt đầu nội suy.
        animation.fromValue = [0.0, 0.1, 0.2]
        // Xác định giá trị mà máy thu sử dụng để kết thúc nội suy.
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
    func startShimmerAnimation(completion: @escaping (() -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
                self.startShimmeringAnimation(animationSpeed: 2.5, direction: .topLeftToBottomRight, repeatCount: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.stopShimmeringAnimation()
                    completion()
                }
            })
        }
    }
}

extension UIView {
    func shake(count: Float = 1, for duration: TimeInterval = 0.1, withTranslation translation: Float = 4) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}

extension UIView {
    func rotate(degrees: CGFloat) {
        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}


protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }

}

extension UIViewController: XibViewController { }

extension UIViewController {
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
  
  func presentWithCustomTransparent(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
      let delegate = SlideInPresentationDelegate()
      delegate.direction = .bottom
      viewControllerToPresent.transitioningDelegate = delegate
      viewControllerToPresent.modalPresentationStyle = .custom
//        viewControllerToPresent.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
      present(viewControllerToPresent, animated: animated, completion: completion)
  }
  
  @objc private func dismissViewController() {
      dismiss(animated: true)
  }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func popReplace() {
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers
        navigationArray.remove(at: navigationArray.count - 2)
        self.navigationController?.viewControllers = navigationArray
        self.pop()
    }
    
    func removeController(asChildViewController viewController: UIViewController) {
        if viewController.isViewLoaded {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
    
    func install(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
    
    func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        if let pres = viewController.presentationController {
            pres.delegate = parentViewController
        }
        parentViewController.present(viewController, animated: true)
        if let pop = viewController.popoverPresentationController {
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
            pop.permittedArrowDirections = arrowDirection
        }
    }
}

extension UIViewController: @retroactive UIAdaptivePresentationControllerDelegate {}

extension UIViewController: @retroactive UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


// 1
enum PresentationTransition: Int {
    case left = 0
    case top = 1
    case right = 2
    case bottom = 3
}

class SlideInPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    // 2
    var direction = PresentationTransition.left
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)

        return presentationController
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: false)
    }

}

class SlideInPresentationController: UIPresentationController {

    var direction: PresentationTransition

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationTransition) {
        self.direction = direction

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        setupBackgroundView()
    }
    
    var backgroundView: UIView!

    func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .black.withAlphaComponent(0.2)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        backgroundView.addGestureRecognizer(recognizer)
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    override func presentationTransitionWillBegin() {
        // 1
        containerView?.insertSubview(backgroundView, at: 0)
        // 2
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: ["backgroundView" : backgroundView!]))

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|", options: [], metrics: nil, views: ["backgroundView" : backgroundView!]))
        // 3
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.alpha = 0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0
        })
    }

    // 1
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    // 2
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(3.0/4.0), height: parentSize.height)
        case .top, .bottom:
            return CGSize(width: parentSize.width, height: parentSize.height)
        }
    }
    // 3
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)

        switch direction {
        case .right:
            frame.origin.x = containerView!.frame.width*(1.0/4.0)
        case .bottom:
            frame.origin.y = 0
        default:
            frame.origin = .zero
        }

        return frame
    }

}

class SlideInPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let direction: PresentationTransition
    
    let isPresentation: Bool
    
    init(direction: PresentationTransition, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 2
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!
        
        // 3
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        // 4
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        // 5
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        // 6
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration, animations: {
            controller.view.frame = finalFrame
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}
