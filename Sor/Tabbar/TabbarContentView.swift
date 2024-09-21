//
//  BasicContentView.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit
import ESTabBarController
import SnapKit

class TabbarContentView: ESTabBarItemContentView {

  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupHighlight()
    setupView()
  }
  
  override func updateLayout() {}
  
  // MARK: - Private function
  private func setupView() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(16)
    }
    titleLabel.font = .systemFont(ofSize: 12)
  }
  
  private func setupHighlight() {
    textColor = R.color.light()!
    highlightTextColor = R.color.primary()!
    iconColor = R.color.light()!
    highlightIconColor = R.color.primary()!
  }
}
