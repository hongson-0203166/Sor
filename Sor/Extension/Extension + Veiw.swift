//
//  Extension + Veiw.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .white { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startCornerValue: UInt = UIRectCorner.topLeft.rawValue { didSet { updatePoints() }}
    @IBInspectable var endCornerValue: UInt = UIRectCorner.topRight.rawValue { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    override init(frame: CGRect) {
        super.init(frame: frame)
        updatePoints()
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updatePoints()
        updateColors()
    }
    
    private func updatePoints() {
        gradientLayer.startPoint = UIRectCorner(rawValue: startCornerValue).point
        gradientLayer.endPoint = UIRectCorner(rawValue: endCornerValue).point
    }
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateColors()
    }
}

extension UIRectCorner {
    var point: CGPoint {
        switch self {
        case .topLeft: return .zero
        case .topRight: return CGPoint(x: 1, y: 0)
        case .bottomLeft: return CGPoint(x: 0, y: 1)
        case .bottomRight: return CGPoint(x: 1, y: 1)
        default: return .zero
        }
    }
}

class GradientViewButton: UIButton {
    @IBInspectable var startColor:   UIColor = .white { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startCornerValue: UInt = UIRectCorner.topLeft.rawValue { didSet { updatePoints() }}
    @IBInspectable var endCornerValue: UInt = UIRectCorner.topRight.rawValue { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    override init(frame: CGRect) {
        super.init(frame: frame)
        updatePoints()
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updatePoints()
        updateColors()
    }
    
    private func updatePoints() {
        gradientLayer.startPoint = UIRectCorner(rawValue: startCornerValue).point
        gradientLayer.endPoint = UIRectCorner(rawValue: endCornerValue).point
    }
    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateColors()
    }
}



import SDWebImage
import UIKit

extension UIImageView {
    @IBInspectable var imageColor: UIColor {
        
        get {
            return tintColor
        }
        
        set {
            setImageColor(color: newValue)
        }
    }
    
    func setImageColor(color: UIColor?) {
        let templateImage = image?.withRenderingMode(.alwaysTemplate)
        image = templateImage
        tintColor = color
    }
    
    func setImage(with urlString: String, placeholderImage: UIImage? = nil, completion: SDExternalCompletionBlock? = nil) {
        SDWebImageDownloader.shared.setValue("ua-lovememo", forHTTPHeaderField: "User-Agent")
        self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholderImage, completed: completion)
    }
}


extension UIView {
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0 ) {
        self.layoutIfNeeded()
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        let borderLayer = CAShapeLayer()
        borderLayer.path = (self.layer.mask! as! CAShapeLayer).path! // Reuse the Bezier path
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.backgroundColor = UIColor.clear
        let roundedShapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

         roundedShapeLayer.frame = self.bounds
         roundedShapeLayer.fillColor = UIColor.white.cgColor
         roundedShapeLayer.path = path.cgPath

         self.layer.insertSublayer(roundedShapeLayer, at: 0)

         self.layer.shadowOpacity = 1
         self.layer.shadowOffset = CGSize(width: 2, height: 4)
         self.layer.shadowRadius = radius
         self.layer.shadowColor = UIColor.lightGray.cgColor
       }
}


extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()

        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)

        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))

        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)

        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))

        //Left Bottom Line
        self.close()
    }
}

extension UIBezierPath {
    /// <#Description#>
    /// - Parameters:
    ///   - fromPoint: the path’s current point to the specified location.
    ///   - toPoint: The destination point of the line segment, specified in the current coordinate system.
    ///   - color:  the color of subsequent stroke and fill operations to the color that the receiver represents.
    ///   - lineWidth: The line width of the path.
    ///   - lineDash: first index is length of dash, second index is length of the gap
    func stroke(
        from fromPoint: CGPoint,
        to toPoint: CGPoint,
        with color: UIColor?,
        lineWidth: CGFloat,
        lineDash: [CGFloat]
    ) {
        move(to: fromPoint)
        addLine(to: toPoint)
        color?.set()
        self.lineWidth = lineWidth
        setLineDash(lineDash, count: lineDash.count, phase: 0)
        stroke()
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
