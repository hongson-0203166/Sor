//
//  CircularProgressViewLayer.swift
//  CircleProgressView
//
//  Created by Admin on 8/7/24.
//

import UIKit

class CircularProgressViewLayer: CALayer {
    @NSManaged var angle: Double
    var radius: CGFloat = 0.0 {
        didSet { invalidateGradientCache() }
    }
    var startAngle: Double = 0.0
    var roundedCorners: Bool = true
    var lerpColorMode: Bool = false
    var progressThickness: CGFloat = 0.5
    var trackThickness: CGFloat = 0.5
    var trackColor: UIColor = .black
    var progressInsideFillColor: UIColor = .clear
    var colorsArray: [UIColor] = [] {
        didSet { invalidateGradientCache() }
    }
    private var gradientCache: CGGradient?
    private var locationsCache: [CGFloat]?
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(angle) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        let progressLayer = layer as! CircularProgressViewLayer
        radius = progressLayer.radius
        angle = progressLayer.angle
        startAngle = progressLayer.startAngle
        roundedCorners = progressLayer.roundedCorners
        lerpColorMode = progressLayer.lerpColorMode
        progressThickness = progressLayer.progressThickness
        trackThickness = progressLayer.trackThickness
        trackColor = progressLayer.trackColor
        colorsArray = progressLayer.colorsArray
        progressInsideFillColor = progressLayer.progressInsideFillColor
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        
        let size = bounds.size
        let width = size.width
        let height = size.height
        
        let trackLineWidth = radius * trackThickness
        let progressLineWidth = radius * progressThickness
        let arcRadius = max(radius - trackLineWidth / 2.0, radius - progressLineWidth / 2.0)
        ctx.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0),
                   radius: arcRadius,
                   startAngle: 0,
                   endAngle: CGFloat.pi * 2,
                   clockwise: false)
        ctx.setStrokeColor(trackColor.cgColor)
        ctx.setFillColor(progressInsideFillColor.cgColor)
        ctx.setLineWidth(trackLineWidth)
        ctx.setLineCap(CGLineCap.butt)
        ctx.drawPath(using: .fillStroke)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let imageCtx = UIGraphicsGetCurrentContext()
        let canonicalAngle = angle.mod(between: 0.0, and: 360.0, byIncrementing: 360.0)
        let fromAngle = -startAngle.radians
        let toAngle: Double = (-canonicalAngle - startAngle).radians
        
        imageCtx?.addArc(center: CGPoint(x: width / 2.0, y: height / 2.0),
                         radius: arcRadius,
                         startAngle: CGFloat(fromAngle),
                         endAngle: CGFloat(toAngle),
                         clockwise: true)
        
        let linecap: CGLineCap = roundedCorners ? .round : .butt
        imageCtx?.setLineCap(linecap)
        imageCtx?.setLineWidth(progressLineWidth)
        imageCtx?.drawPath(using: .stroke)
        
        let drawMask: CGImage = UIGraphicsGetCurrentContext()!.makeImage()!
        UIGraphicsEndImageContext()
        
        ctx.saveGState()
        ctx.clip(to: bounds, mask: drawMask)
        
        if colorsArray.isEmpty {
            fillRect(withContext: ctx, color: .white)
        } else if colorsArray.count == 1 {
            fillRect(withContext: ctx, color: colorsArray[0])
        } else if lerpColorMode {
            lerp(withContext: ctx, colorsArray: colorsArray)
        } else {
            drawGradient(withContext: ctx, colorsArray: colorsArray)
        }

        ctx.restoreGState()
        UIGraphicsPopContext()
    }
    
    private func lerp(withContext context: CGContext, colorsArray: [UIColor]) {
        let canonicalAngle = angle.mod(between: 0.0, and: 360.0, byIncrementing: 360.0)
        let percentage = canonicalAngle / 360.0
        let steps = colorsArray.count - 1
        let step = 1.0 / Double(steps)
        
        for i in 1...steps {
            let di = Double(i)
            if percentage <= di * step || i == steps {
                let colorT = percentage.inverseLerp(min: (di - 1) * step, max: di * step)
                let color = colorT.colorLerp(minColor: colorsArray[i - 1], maxColor: colorsArray[i])
                fillRect(withContext: context, color: color)
                break
            }
        }
    }
    
    private func fillRect(withContext context: CGContext, color: UIColor) {
        context.setFillColor(color.cgColor)
        context.fill(bounds)
    }
    
    private func drawGradient(withContext context: CGContext, colorsArray: [UIColor]) {
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let locations = locationsCache ?? gradientLocationsFor(colorCount: colorsArray.count, gradientWidth: bounds.size.width)
        let gradient: CGGradient
        
        if let cachedGradient = gradientCache {
            gradient = cachedGradient
        } else {
            guard let newGradient = CGGradient(colorSpace: baseSpace, colorComponents: colorsArray.rgbNormalized.componentsJoined,
                                               locations: locations, count: colorsArray.count) else { return }
            
            gradientCache = newGradient
            gradient = newGradient
        }
        
        let halfX = bounds.size.width / 2.0
        let floatPi = CGFloat.pi
        let angleInRadians: CGFloat = 0
        let oppositeAngle = angleInRadians > floatPi ? angleInRadians - floatPi : angleInRadians + floatPi
        
        let startPoint = CGPoint(x: (cos(angleInRadians) * halfX) + halfX, y: (sin(angleInRadians) * halfX) + halfX)
        let endPoint = CGPoint(x: (cos(oppositeAngle) * halfX) + halfX, y: (sin(oppositeAngle) * halfX) + halfX)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
    }
    
    private func gradientLocationsFor(colorCount: Int, gradientWidth: CGFloat) -> [CGFloat] {
        guard colorCount > 0, gradientWidth > 0 else { return [] }

        let progressLineWidth = radius * progressThickness
        let firstPoint = gradientWidth / 2.0 - (radius - progressLineWidth / 2.0)
        let increment = (gradientWidth - (2.0 * firstPoint)) / CGFloat(colorCount - 1)
        
        let locationsArray = (0..<colorCount).map { firstPoint + (CGFloat($0) * increment) }
        let result = locationsArray.map { $0 / gradientWidth }
        locationsCache = result
        return result
    }
    
    private func invalidateGradientCache() {
        gradientCache = nil
        locationsCache = nil
    }
}
