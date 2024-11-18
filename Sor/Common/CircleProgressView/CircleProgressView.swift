//
//  CircleProgressView.swift
//  CircleProgressView
//
//  Created by Admin on 8/7/24.
//

import UIKit

@IBDesignable
class CircleProgressView: UIView, CAAnimationDelegate {
    // Lớp layer thực hiện animation của view
    private var progressLayer: CircularProgressViewLayer {
        get {
            return layer as! CircularProgressViewLayer
        }
    }
    
    // Bo góc tròn cho vùng animation bên ngoài và vùng trong
    private var radius: CGFloat = 0.0 {
        didSet {
            progressLayer.radius = radius
        }
    }
    
    // Tiến trình thực hiện animation
    public var progress: Double {
        get { return angle.mod(between: 0.0, and: 360.0, byIncrementing: 360.0) / 360.0 }
        set { angle = newValue.clamp(lowerBound: 0.0, upperBound: 1.0) * 360.0 }
    }
    
    // Góc biểu thị cho % animation được thực hiện (ví dụ 270 tính theo từ 0 đến 360)
    @IBInspectable public var angle: Double = 0.0 {
        didSet {
            pauseIfAnimating()
            progressLayer.angle = angle
        }
    }
    
    // Góc bắt đầu (nếu để mặc định là 0 nó sẽ nằm ngang)
    @IBInspectable public var startAngle: Double = 0.0 {
        didSet {
            startAngle = startAngle.mod(between: 0.0, and: 360.0, byIncrementing: 360.0)
            progressLayer.startAngle = startAngle
            progressLayer.setNeedsDisplay()
        }
    }
    
    // bo góc layer
    @IBInspectable public var roundedCorners: Bool = true {
        didSet {
            progressLayer.roundedCorners = roundedCorners
        }
    }
    
    // Chế độ màu lerp (Chuyển đổi mượt giữa 2 vùng màu)
    @IBInspectable public var lerpColorMode: Bool = false {
        didSet {
            progressLayer.lerpColorMode = lerpColorMode
        }
    }
    
    // Độ rộng của vùng tiến trình
    // Vùng tròn trung tâm sẽ cần chiếm khoảng 50% diện tích, nên tham số truyền vào sẽ được chia 2 tính từ mép ngoài view cho đến phần 50% diện tích đó
    @IBInspectable public var progressThickness: CGFloat = 0.4 {
        didSet {
            progressThickness = progressThickness.clamp(lowerBound: 0.0, upperBound: 1.0)
            progressLayer.progressThickness = progressThickness
        }
    }
    
    // Độ rộng của vùng viền tròn bên ngoài
    @IBInspectable public var trackThickness: CGFloat = 0.5 {//Between 0 and 1
        didSet {
            trackThickness = trackThickness.clamp(lowerBound: 0.0, upperBound: 1.0)
            progressLayer.trackThickness = trackThickness
        }
    }
    
    // Màu sắc của viền tròn bên ngoài
    @IBInspectable public var trackColor: UIColor = .black {
        didSet {
            progressLayer.trackColor = trackColor
            progressLayer.setNeedsDisplay()
        }
    }
    
    // Màu sắc của vòng tròn bên trong
    @IBInspectable public var progressInsideFillColor: UIColor? = nil {
        didSet {
            progressLayer.progressInsideFillColor = progressInsideFillColor ?? .clear
        }
    }
    
    // Kết thúc animation
    private var animationCompletionBlock: ((Bool) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setInitialValues()
        refreshValues()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        setInitialValues()
        refreshValues()
    }
    
    override class var layerClass: AnyClass {
        return CircularProgressViewLayer.self
    }
    
    override func didMoveToWindow() {
        window.map { progressLayer.contentsScale = $0.screen.scale }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            pauseIfAnimating()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setInitialValues()
        refreshValues()
        progressLayer.setNeedsDisplay()
    }
    
    private func setInitialValues() {
        radius = frame.size.width / 2.0 * 0.9
        backgroundColor = .clear
    }
    
    private func refreshValues() {
        progressLayer.angle = angle
        progressLayer.startAngle = startAngle
        progressLayer.roundedCorners = roundedCorners
        progressLayer.lerpColorMode = lerpColorMode
        progressLayer.progressThickness = progressThickness / 2.0
        progressLayer.trackColor = trackColor
        progressLayer.trackThickness = trackThickness / 2.0
    }
}

extension CircleProgressView {
    func set(colors: UIColor...) {
        progressLayer.colorsArray = colors
        progressLayer.setNeedsDisplay()
    }
    
    func animate(fromAngle: Double, toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        pauseIfAnimating()
        let animationDuration: TimeInterval
        if relativeDuration {
            animationDuration = duration
        } else {
            let traveledAngle = (toAngle - fromAngle).mod(between: 0.0, and: 360.0, byIncrementing: 360.0)
            let scaledDuration = TimeInterval(traveledAngle) * duration / 360.0
            animationDuration = scaledDuration
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(CircularProgressViewLayer.angle))
        animation.fromValue = fromAngle
        animation.toValue = toAngle
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        angle = toAngle
        animationCompletionBlock = completion
        
        progressLayer.add(animation, forKey: "angle")
    }
    
    func animate(toAngle: Double, duration: TimeInterval, relativeDuration: Bool = true, completion: ((Bool) -> Void)?) {
        pauseIfAnimating()
        animate(fromAngle: angle, toAngle: toAngle, duration: duration, relativeDuration: relativeDuration, completion: completion)
    }
    
    func pauseAnimation() {
        guard let presentationLayer = progressLayer.presentation() else { return }
        
        let currentValue = presentationLayer.angle
        progressLayer.removeAllAnimations()
        angle = currentValue
    }
    
    func pauseIfAnimating() {
        if isAnimating() {
            pauseAnimation()
        }
    }
    
    func stopAnimation() {
        progressLayer.removeAllAnimations()
        angle = 0
    }
    
    func isAnimating() -> Bool {
        return progressLayer.animation(forKey: "angle") != nil
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCompletionBlock?(flag)
        animationCompletionBlock = nil
    }
}

