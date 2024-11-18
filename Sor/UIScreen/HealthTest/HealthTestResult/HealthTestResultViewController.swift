//
//  HealthTestResultViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 27/09/2024.
//

import UIKit

class HealthTestResultViewController: BaseViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var leadingSliderViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTestName: UILabel!
    @IBOutlet weak var lblMinPoint: UILabel!
    @IBOutlet weak var lblMaxPoint: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblLowDes: UILabel!
    @IBOutlet weak var lblMedium: UILabel!
    @IBOutlet weak var lblMediumDes: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblHighDes: UILabel!
    @IBOutlet weak var lblSchdule: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    private let viewModel: HealthTestResultViewModel
    
    init(data: HealthTestModel) {
        viewModel = HealthTestResultViewModel(data: data)
        super.init(nibName: Self.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let caculateTotalGrade = viewModel.data.caculateTotalGrade else {return}
        
        let distanceActual = sliderView.width - circleView.width
        let ratio = CGFloat(viewModel.currentGrade) / CGFloat(caculateTotalGrade)
        
        UIView.animate(withDuration: 1.5) { [weak self] in
            guard let `self` = self else {return}
            
            self.circleView.x = distanceActual * ratio
        }
    }
    
    override func configView() {
//        lblTitle.font = R.font.outfitBold(size: 36)
        lblTitle.text = "Your Results Are\n Ready!"
//        lblTestName.font = R.font.outfitSemiBold(size: 24)
        lblTestName.adjustsFontSizeToFitWidth = true
        lblTestName.text = "\(viewModel.data.title ?? "") Test Score"
//        lblMinPoint.font = R.font.outfitSemiBold(size: 14)
//        lblMaxPoint.font = R.font.outfitSemiBold(size: 14)
        lblMaxPoint.text = "\(viewModel.data.caculateTotalGrade ?? 0)"
//        lblPoint.font = R.font.outfitSemiBold(size: 14)
        lblPoint.text = "\(viewModel.currentGrade)"
//        lblLow.font = R.font.outfitMedium(size: 14)
        lblLow.adjustsFontSizeToFitWidth = true
        lblLow.text = "\(viewModel.evaluateMin().min)-\(viewModel.evaluateMin().max) points"
//        lblMedium.font = R.font.outfitMedium(size: 14)
        lblMedium.adjustsFontSizeToFitWidth = true
        lblMedium.text = "\(viewModel.evaluateMax().min)-\(viewModel.evaluateMax().max) points"
//        lblHigh.font = R.font.outfitMedium(size: 14)
        lblHigh.adjustsFontSizeToFitWidth = true
        lblHigh.text = "\(viewModel.evaluateHigh().min)-\(viewModel.evaluateHigh().max) points"
//        lblLowDes.font = R.font.outfitMedium(size: 14)
//        lblMediumDes.font = R.font.outfitMedium(size: 14)
//        lblHighDes.font = R.font.outfitMedium(size: 14)
//        lblSchdule.font = R.font.outfitMedium(size: 16)
        lblSchdule.text = viewModel.evaluate().text
        
//        btnBack.titleLabel?.font = R.font.outfitSemiBold(size: 18)
        
        switch viewModel.evaluate().type {
        case .low:
            lblLow.backgroundColor = UIColor(hex: 0x488BFC).withAlphaComponent(0.4)
        case .medium:
            lblMedium.backgroundColor = UIColor(hex: 0x488BFC).withAlphaComponent(0.4)
        case .high:
            lblHigh.backgroundColor = UIColor(hex: 0x488BFC).withAlphaComponent(0.4)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popTo(type: HealthTestListViewController.self)
    }
}


extension UINavigationController {
    func popTo<T: UIViewController>(type: T.Type) {
        guard let vc = self.viewControllers.filter({ $0 is T}).first else {return}
        self.popToViewController(vc, animated: true)
    }
}


extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }
    
    static var className: String {
        String(describing: self)
    }
}
