//
//  PulseViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit
import Lottie

class PulseViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgNote: UIImageView!
    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var measuringView: UIView!
    @IBOutlet weak var lblMeasuring: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var viewBpmValue: UIView!
    @IBOutlet weak var lblBpmValue: UILabel!
    @IBOutlet weak var viewDivBpm: UIView!
    @IBOutlet weak var lblBpm: UILabel!
    @IBOutlet weak var viewMsValue: UIView!
    @IBOutlet weak var lblMsValue: UILabel!
    @IBOutlet weak var viewDivMs: UIView!
    @IBOutlet weak var lblMs: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var viewHold: UIView!
    @IBOutlet weak var lblHold: UILabel!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblResultSub: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    private var viewModel = HeartRateViewModel()
    
    init(pushWhenDismiss: Bool = true) {
        viewModel.pushWhenDismiss = pushWhenDismiss
        super.init(nibName: PulseViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVideoCapture()

        viewModel.pulseSubject.sink { [weak self] pulse in
            guard let `self` = self else {return}
            
            self.lblBpmValue.text = "\(pulse)"
            self.lblMsValue.text = "\(viewModel.calculateHRV(bpm: CGFloat(pulse)))"
        }.store(in: &cancelable)
        
        viewModel.readyFindPulseSubject.sink { [weak self] ready in
            guard let `self` = self else {return}
        
            self.measuringView.isHidden = !ready
            self.lblProgress.isHidden = !ready
            self.viewPhone.isHidden = ready
            self.viewHold.isHidden = !ready
            self.viewResult.isHidden = true
            self.viewDivMs.isHidden = ready
            self.viewDivBpm.isHidden = ready
            self.viewBpmValue.isHidden = !ready
            self.viewMsValue.isHidden = !ready
            self.animationView.isHidden = !ready
            self.imgBack.isUserInteractionEnabled = !ready
            self.imgNote.isUserInteractionEnabled = !ready
            
            if ready {
                self.startAnimPulse()
                self.animationView.play()
            } else {
                self.stopAnimPulse()
                self.animationView.stop()
            }
        }.store(in: &cancelable)
        
        viewModel.didFinishScanSubject.sink { [weak self] _ in
            guard let `self` = self else {return}
            
            lblProgress.text = "100%"
            progressView.angle = 360
            viewModel.doneAnimPulse()
            animationView.stop()
            imgBack.isUserInteractionEnabled = false
            imgNote.isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let `self` = self else {return}
                
                dismiss(animated: true) {
                        self.pushToHeartResult()
                }
            }
        }.store(in: &cancelable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.resetData()
        viewModel.initCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.deinitCaptureSession()
    }
    
    override func configView() {
        initProgressView()
        initViewAnimation()

      lblProgress.isHidden = true
      lblProgress.font = .boldSystemFont(ofSize: 20)
      lblTitle.font = .boldSystemFont(ofSize: 20)
      lblBpmValue.font = .boldSystemFont(ofSize: 28)
      lblMsValue.font = .boldSystemFont(ofSize: 28)
      lblBpm.font = .systemFont(ofSize: 20, weight: .medium)
      lblMs.font = .systemFont(ofSize: 20, weight: .medium)
      lblPhone.font = .systemFont(ofSize: 18, weight: .medium)
      lblHold.font = .systemFont(ofSize: 18, weight: .medium)
      lblResult.font = .boldSystemFont(ofSize: 22)
      lblHold.font = .systemFont(ofSize: 18)
      
        viewBpmValue.isHidden = true
        viewMsValue.isHidden = true
        viewHold.isHidden = true
        viewResult.isHidden = true
        viewPhone.isHidden = false
        cameraView.isHidden = false
        measuringView.isHidden = true
        
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        imgNote.isUserInteractionEnabled = true
        imgNote.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapNote)))
    }
    
    private func initProgressView() {
        progressView.startAngle = -90
        progressView.progressThickness = 32 / 220
        progressView.trackThickness = 36 / 220
        progressView.set(colors: UIColor(hex: 0xE83E56))
        progressView.roundedCorners = true
        progressView.layer.shadowOffset = .init(width: 0, height: 3)
        progressView.layer.shadowColor = UIColor.gray.cgColor
        progressView.layer.shadowRadius = 3
        progressView.layer.shadowOpacity = 0.4
    }
    
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: cameraView.bounds.size)
        viewModel.heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: cameraView.layer)
        viewModel.heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
            viewModel.handle(buffer: imageBuffer)
        }
    }
    
    @objc
    private func handleAminTimer() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            //MARK: progress 30s
            self.viewModel.progress += 0.2
            let progress = self.viewModel.progress * 100 / 30
            self.lblProgress.text = "\(Int(progress))%"
            self.progressView.angle = Double(progress / 100 * 360)
            
            if progress > 0 && progress <= 25 {
                viewHold.isHidden = false
                viewResult.isHidden = true
                
                lblHold.text = "Hold your finger still... Make sure you don't apply too much pressure to the camera lens."
            } else if progress > 25 && progress <= 45 {
                viewHold.isHidden = false
                viewResult.isHidden = true
                
                lblHold.text = "To get accurate results, measure your heart rate when you are at rest, not stressed, or have not just finished exercising."
            } else {
                viewHold.isHidden = true
                viewResult.isHidden = false
            }
        }
    }
    
    @objc
    private func tapBack() {
        if viewModel.pushWhenDismiss {
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc
    private func tapNote() {
    }
}

extension PulseViewController {
    private func startAnimPulse() {
        viewModel.timerAnimPulse = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleAminTimer), userInfo: nil, repeats: true)
    }
    
    private func stopAnimPulse() {
        if viewModel.timerAnimPulse != nil {
            lblProgress.text = "0%"
            progressView.angle = 0
            viewModel.stopAnimPulse()
        }
    }
    
    private func initViewAnimation() {
        animationView.animation = LottieAnimation.named("heartbeat")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
    }
  
  private func pushToHeartResult() {
      let model = NewHeartRateModel(bpm: viewModel.averageHeartRate, hrv: viewModel.hrv)
      let nav = UINavigationController(rootViewController: HeartRateResultViewController(model: model, pushWhenDismiss: viewModel.pushWhenDismiss))
    VCService.present(controller: nav)
  }
}
