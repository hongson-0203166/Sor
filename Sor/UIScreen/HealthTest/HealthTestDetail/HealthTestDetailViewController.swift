//
//  HealthTestDetailViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 20/09/2024.
//

import UIKit

class HealthTestDetailViewController: BaseViewController {
    @IBOutlet weak var imgContent: ImageLoader!
    @IBOutlet weak var parentView: GradientView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumberOfQues: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var adsView: UIView!
    
    private let viewModel: HealthTestDetailViewModel
    
    init(data: HealthTestModel) {
        viewModel = HealthTestDetailViewModel(data: data)
        super.init(nibName: Self.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        parentView.roundCorners(bottomLeft: 22, bottomRight: 22)
        imgContent.roundCorners(bottomLeft: 22, bottomRight: 22)
    }
    
    override func configView() {
        parentView.startCornerValue = UIRectCorner.bottomLeft.rawValue
        parentView.endCornerValue = UIRectCorner.topLeft.rawValue
        parentView.startColor = UIColor(hex: 0x0A0F1E).withAlphaComponent(0.45)
        parentView.endColor = .clear
        
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        
//        btnNext.titleLabel?.font = R.font.outfitSemiBold(size: 18)
        
        imgContent.loadImageWithUrl(viewModel.data.imageDetail)
        lblTitle.text = viewModel.data.title
//        lblTitle.font = R.font.outfitBold(size: 28)
        lblTime.text = "\(Int(viewModel.data.time ?? 0)) mins"
//        lblTime.font = R.font.outfitRegular(size: 14)
        lblNumberOfQues.text = "\(viewModel.data.questions?.count ?? 0) questions"
//        lblNumberOfQues.font = R.font.outfitRegular(size: 14)
        lblDescription.text = viewModel.data.description
//        lblDescription.font = R.font.outfitRegular(size: 18)
        lblDescription.addInterlineSpacing(spacingValue: 2.5, alignment: .left)
        
    }
    
    @objc
    private func tapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        let vc = HealthTestQuestionViewController(data: viewModel.data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
