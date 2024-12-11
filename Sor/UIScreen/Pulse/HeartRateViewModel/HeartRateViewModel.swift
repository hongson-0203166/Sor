//
//  HeartRateViewModel.swift
//  HeartCare
//
//  Created by Admin on 8/7/24.
//

import Combine
import UIKit
import AVFoundation

class HeartRateViewModel {
    private var validFrameCounter = 0
    private var measurementStartedFlag = false
    private var inputs: [CGFloat] = []
    private var pulseDetector = PulseDetector()
    private var timer: Timer? = Timer()
    private let defaultSecondsRemaining = 30
    private var setSecondsRemaining = 30
    private var pulseData: [Int] = []
    
    var pushWhenDismiss = true
    
    var progress: Float = 0
    var timerAnimPulse: Timer?
    
    var averageHeartRate: Int {
        get {
            let sum = pulseData.reduce(0, +)
            let average = Double(sum) / Double(pulseData.count)
            return average.isNaN ? 0 : Int(average.rounded(.toNearestOrAwayFromZero))
        }
    }
    
    var hrv: Int {
        get {
            return calculateHRV(bpm: averageHeartRate.toCGFloat)
        }
    }
    
    var heartRateManager: HeartRateManager!
    var readyFindPulseSubject = PassthroughSubject<Bool, Never>()
    var pulseSubject = PassthroughSubject<Int, Never>()
    var didFinishScanSubject = PassthroughSubject<Int, Never>()
}

// MARK: - Camera
extension HeartRateViewModel {
    func initCaptureSession() {
        heartRateManager.startCapture()
    }
    
    func deinitCaptureSession() {
        heartRateManager.stopCapture()
        toggleTorch(status: false)
    }
    
    func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    func handle(buffer: CMSampleBuffer) {
       var redmean:CGFloat = 0.0;
       var greenmean:CGFloat = 0.0;
       var bluemean:CGFloat = 0.0;
       
       let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
       let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

       let extent = cameraImage.extent
       let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
       let averageFilter = CIFilter(name: "CIAreaAverage",
                             parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
       let outputImage = averageFilter.outputImage!

       let ctx = CIContext(options:nil)
       let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
       
       let rawData:NSData = cgImage.dataProvider!.data!
       let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
       let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
       var BGRA_index = 0
       for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
           switch BGRA_index {
           case 0:
               bluemean = CGFloat(pixel)
           case 1:
               greenmean = CGFloat(pixel)
           case 2:
               redmean = CGFloat(pixel)
           case 3:
               break
           default:
               break
           }
           BGRA_index += 1
       }
       
        let hsv = ColorUtils.rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
       if (hsv.1 > 0.5 && hsv.2 > 0.5) {
           DispatchQueue.main.async {
               if !self.measurementStartedFlag {
                   self.toggleTorch(status: true)
                   self.readyFindPulseSubject.send(true)
                   self.startMeasurement()
                   self.measurementStartedFlag = true
               }
           }
           validFrameCounter += 1
           inputs.append(hsv.0)
           // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
           let filtered = Filter.MKFilter.processValue(value: Double(hsv.0))
           if validFrameCounter > 30 {
               let _ = self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
           }
       } else {
           validFrameCounter = 0
           measurementStartedFlag = false
           pulseDetector.reset()
           DispatchQueue.main.async {
               self.resetData()
               self.readyFindPulseSubject.send(false)
           }
       }
   }
    
    func startMeasurement() {
        DispatchQueue.main.async {
            self.toggleTorch(status: true)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { return }
                self.setSecondsRemaining -= 1
                let average = self.pulseDetector.getAverage()
                let pulse = 60.0 / average
                let scan = ScanPulseType(rawValue: self.setSecondsRemaining)
                switch scan {
                case .end:
                    if self.timer != nil {
                        timer.invalidate()
                        self.timer = nil
                        self.heartRateManager.stopCapture()
                        self.didFinishScanSubject.send(self.averageHeartRate)
                    }
                default:
                    if pulse < 0 {
                        self.pulseSubject.send(lroundf(pulse * -1))
                        self.pulseData.append(Int(pulse * -1))
                    } else {
                        self.pulseSubject.send(lroundf(pulse))
                        self.pulseData.append(Int(pulse))
                    }
                }
            })
        }
    }
    
    func resetData() {
        setSecondsRemaining = defaultSecondsRemaining
        pulseData.removeAll()
        timer?.invalidate()
        timer = nil
    }
    
    func stopAnimPulse() {
        timerAnimPulse?.invalidate()
        timerAnimPulse = nil
        progress = 0
    }
    
    func doneAnimPulse() {
        timerAnimPulse?.invalidate()
        timerAnimPulse = nil
        progress = 1
    }
}

extension HeartRateViewModel {
    func calculateHRV(bpm: CGFloat) -> Int {
        let rrInterval: CGFloat = 60.0 / bpm
        let hrv = rrInterval.roundToDecimal(1) * 100
        return Int(hrv)
    }
    
    func calculateHRV(heartRateData: [Int]) -> Int {
        if heartRateData.count < 5 {
            return 0
        }
        var heartRateDistances: [Double] = []
        
        for (index, value) in heartRateData.enumerated() {
            let distance = heartRateData[index + 1] - value
            let ms: Double = (abs(Double(distance)) / 60.0)
            heartRateDistances.append(ms)
        }

        let sum = heartRateDistances.reduce(0, +)
        let averageDistance = Double(sum) / Double(heartRateDistances.count)
        return Int(averageDistance * 1000)
    }
}
