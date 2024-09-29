//
//  RecommendTestPermissionView.swift
//  PulseTrack
//
//  Created by Admin on 14/8/24.
//

import UIKit

class RecommendTestPermissionView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var btnGotIt: UIButton!
    
    var bgView = UIView()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
      lblTitle.font = .systemFont(ofSize: 20, weight: .medium)
        lblTitle.addInterlineSpacing(spacingValue: 1, alignment: .center)
      lblSub.font = .systemFont(ofSize: 16)
      btnGotIt.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    @IBAction func btnGotItTapped(_ sender: Any) {
       
        bgView.removeFromSuperview()
        self.removeFromSuperview()
    }
}

extension RecommendTestPermissionView {
    static func show(in view: UIView) {
        let permissionView: RecommendTestPermissionView = RecommendTestPermissionView.loadFromNib()
        view.addSubview(permissionView.bgView)
        permissionView.bgView.backgroundColor = .black.withAlphaComponent(0.15)
        permissionView.bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(permissionView)
        permissionView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp_centerXWithinMargins)
            make.centerY.equalTo(view.snp_centerYWithinMargins)
            make.width.equalTo(WIDTH_SCREEN - 48)
        }
        
        view.bringSubviewToFront(permissionView.bgView)
        view.bringSubviewToFront(permissionView)

        permissionView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.35, delay: 0) {
            permissionView.transform = .identity
        }
    }
}

