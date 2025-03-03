//
//  HeartRateResultViewController.swift
//  HeartCare
//
//  Created by Admin on 9/7/24.
//

import UIKit
import Lottie

class HeartRateResultViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPulse: UILabel!
    @IBOutlet weak var lblPulseValue: UILabel!
    @IBOutlet weak var lblPulseUnit: UILabel!
    @IBOutlet weak var lblHrv: UILabel!
    @IBOutlet weak var lblHrvValue: UILabel!
    @IBOutlet weak var lblHrvUnit: UILabel!
    @IBOutlet weak var lineProgressView: UIView!
    @IBOutlet weak var lblResultTitle: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var viewMainProgress: UIView!
    @IBOutlet weak var viewProgress: UIView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblPersonal: UILabel!
    @IBOutlet weak var lblGive: UILabel!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var lblEncouragement: UILabel!
    @IBOutlet weak var lblEncouragementDes: UILabel!
    @IBOutlet weak var lblSuggestion: UILabel!
    @IBOutlet weak var tableView: AutoReSizeTableView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval?
    private var animationDuration: CFTimeInterval = 1.5
    
    private let viewModel: HeartRateResultViewModel
    
    init(model: NewHeartRateModel, pushWhenDismiss: Bool = true) {
        viewModel = HeartRateResultViewModel(model: model)
        viewModel.pushWhenDismiss = pushWhenDismiss
        
        super.init(nibName: HeartRateResultViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let distanceActual = lineProgressView.width - viewProgress.width
        let ratio = Double(viewModel.model.bpm) / viewModel.maxPulse
        
        animationStartTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
        displayLink?.add(to: .main, forMode: .default)
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let `self` = self else {return}
            
            self.viewMainProgress.x = distanceActual * CGFloat(ratio)
        } completion: { [weak self] _ in
            guard let `self` = self else {return}

            self.displayLink?.invalidate()
            self.displayLink = nil
            
            // Xử lý đổi màu view khi kết thúc animation
            let actualPulse = viewMainProgress.x / distanceActual * viewModel.maxPulse
            viewProgress.backgroundColor = HeartRateResultType.getType(pulse: actualPulse).value.color
        }
    }
  
  override func setupObservable() {
    let object = viewModel.model.toObject()
    RealmManager.shared.save(object)
  }
    
    override func configView() {
        initComponents()
        initTableView()
        initAnimationView()
    }
            
    @IBAction func btnContinueTapped(_ sender: Any) {
        
//        let object = viewModel.model.toObject()
//        RealmManager.shared.save(object)
        
        dismiss(animated: true) { [weak self] in
            guard let `self` = self else {return}
            
            if self.viewModel.pushWhenDismiss {
                // Xử lý push khi màn đang đứng không phải là history
//                VCService.push(controller: MeasurementHistoryViewController(tabIndex: HistoryCateType.heartRate.rawValue))
            } else {
                // Xử lý khi màn đang đứng là màn history, khi đó chỉ reload data tại màn này
//                let userInfo: [String: Any] = [
//                    "tabIndex": HistoryCateType.heartRate.rawValue
//                ]
//                NotificationCenter.default.post(name: .ReloadHistory, object: nil, userInfo: userInfo)
            }
        }
    }
}

// MARK: - Init
extension HeartRateResultViewController {
    private func initComponents() {
//        lblTitle.font = R.font.outfitSemiBold(size: 20)
//        lblPulse.font = R.font.outfitRegular(size: 18)
//        lblPulseValue.font = R.font.outfitBold(size: 30)
//        lblPulseUnit.font = R.font.outfitRegular(size: 16)
//        lblHrv.font = R.font.outfitRegular(size: 18)
//        lblHrvValue.font = R.font.outfitBold(size: 30)
//        lblHrvUnit.font = R.font.outfitRegular(size: 16)
//        lblResultTitle.font = R.font.outfitMedium(size: 20)
//        lblLow.font = R.font.outfitMedium(size: 14)
//        lblHigh.font = R.font.outfitMedium(size: 14)
//        lblValue.font = R.font.outfitSemiBold(size: 14)
//        lblType.font = R.font.outfitSemiBold(size: 14)
//        lblPersonal.font = R.font.outfitMedium(size: 17)
//        lblPersonal.textColor = UIColor(hex: 0x152238)
//        lblGive.font = R.font.outfitRegular(size: 12)
//        lblGive.textColor = UIColor(hex: 0x6D6D6D)
//        lblEncouragement.font = R.font.outfitMedium(size: 17)
//        lblEncouragement.textColor = UIColor(hex: 0x0F1827)
//        lblSuggestion.font = R.font.outfitMedium(size: 17)
//        lblSuggestion.textColor = UIColor(hex: 0x0F1827)
//        lblEncouragementDes.font = R.font.outfitRegular(size: 16)
        lblEncouragementDes.textColor = UIColor(hex: 0x353F50)
        lblEncouragementDes.text = HeartRateResultType.getType(pulse: Double(viewModel.model.bpm)).encouragement
        
        lblValue.text = "\(viewModel.model.bpm)"
        lblType.text = HeartRateResultType.getType(pulse: Double(viewModel.model.bpm)).value.text
        lblPulseValue.text = "\(viewModel.model.bpm)"
        lblHrvValue.text = "\(viewModel.model.hrv)"
        
        lineProgressView.layer.cornerRadius = 5
        lineProgressView.layer.masksToBounds = true
        //btnContinue.titleLabel?.font = R.font.outfitSemiBold(size: 18)
    }
    
    private func initTableView() {
        tableView.registerCell(HeartRateResultCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 40
        tableView.setHeightForHeader()
        tableView.setHeightForFooter()
    }
    
    private func initAnimationView() {
        animationView.animation = LottieAnimation.named("heart_chat")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.3
        animationView.play()
    }
}

// MARK: - Objc
extension HeartRateResultViewController {
    @objc
    private func handleDisplayLink() {
        guard let startTime = animationStartTime else { return }
        let elapsedTime = CACurrentMediaTime() - startTime
        let actualX = viewMainProgress.x * elapsedTime / animationDuration
        let distanceActual = lineProgressView.width - viewProgress.width
        let actualPulse = actualX / distanceActual * viewModel.maxPulse
        
        // Xử lý đổi màu view khi animation đang khởi chạy
        viewProgress.backgroundColor = HeartRateResultType.getType(pulse: actualPulse).value.color
    }
    
//    @objc
//    private func tapChat() {
//        if !UserDefaults.standard.isUserVip {
//            if UserDefaults.standard.countShowChatHeartRate >= 1 {
//                VCService.showIAP(source: .personal_therapist_2, overTabbar: false, onSuccess: { [weak self] in
//                    guard let `self` = self else {return}
//                    self.pushToChat()
//                }, onClose: nil)
//            } else {
//                pushToChat()
//            }
//        } else {
//            pushToChat()
//        }
//    }
}

// MARK: - func
extension HeartRateResultViewController {
    func pushToChat() {
//        if let _ = UserDefaults.standard.loginInfo {
//            VCService.push(controller: HeartRateChatViewController())
//        } else {
//            VCService.push(controller: LoginViewController(flow: .heart_result))
//        }
    }
}

// MARK: - UITableView
extension HeartRateResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeartRateResultType.getType(pulse: Double(viewModel.model.bpm)).suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: HeartRateResultCell.self, for: indexPath)
        cell.setupData(text: HeartRateResultType.getType(pulse: Double(viewModel.model.bpm)).suggestions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
