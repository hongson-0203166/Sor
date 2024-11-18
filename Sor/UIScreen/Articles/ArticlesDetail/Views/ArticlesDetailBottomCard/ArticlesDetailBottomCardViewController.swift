//
//  BottomCardViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 3/10/2024.
//

import UIKit

protocol ArticlesDetailBottomCardViewControllerDelegate: AnyObject {
    func articlesDetailBottomCardViewControllerDidScroll(offset y: CGFloat)
}

class ArticlesDetailBottomCardViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewConstraint: NSLayoutConstraint!
    
    weak var delegate: ArticlesDetailBottomCardViewControllerDelegate?
    
    private let articlesModel: ArticlesModel!
    
    var offsetBottom: CGFloat = 0 {
        didSet {
            guard let bottomScrollConstraint else {return}
            bottomScrollConstraint.constant = offsetBottom
            bottomStackViewConstraint.constant = offsetBottom + 150
        }
    }
        
    init(articlesModel: ArticlesModel) {
        self.articlesModel = articlesModel
        super.init(nibName: Self.name, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configView() {
        initComponents()
        initScrollView()
        initStackView()
    }
}

extension ArticlesDetailBottomCardViewController {
    private func initComponents() {
      lblTitle.font = .systemFont(ofSize: 28, weight: .semibold)
        lblTitle.textColor = UIColor(hex: 0x152238)
      lblTime.font = .systemFont(ofSize: 14)
        lblTime.textColor = UIColor(hex: 0xA09D9D)
        
        lblTitle.text = articlesModel.title
        lblTime.text = articlesModel.timeReading
    }
    
    private func initScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func initStackView() {
        stackView.subviews.forEach({
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        
        for item in articlesModel.story {
            let label = UILabel()
            label.numberOfLines = 0
          label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor(hex: 0x243044)
            label.text = item
            
            stackView.addArrangedSubview(label)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ArticlesDetailBottomCardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
        
        delegate?.articlesDetailBottomCardViewControllerDidScroll(offset: scrollView.contentOffset.y)
    }
}
