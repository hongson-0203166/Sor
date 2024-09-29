//
//  ArticlesDetailViewController.swift
//  HeartCare
//
//  Created by Admin on 26/06/2024.
//

import UIKit
import SnapKit
import Combine
import SwiftUI

class ArticlesDetailViewController: BaseViewController {
    @IBOutlet weak var imageLoader: ImageLoader!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewGoTo: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblGoTo: UILabel!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var parentAdsView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    private var viewModel: ArticlesDetailViewModel!
    
    private var cardBottomViewController: ArticlesDetailBottomCardViewController!
    
    init(articlesModel: ArticlesModel) {
        self.viewModel = ArticlesDetailViewModel(articlesModel: articlesModel)
        super.init(nibName: Self.name, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.cardBottomMaxHeight = self.view.frame.height - viewHeader.frame.origin.y - viewHeader.frame.size.height
        viewModel.cardBottomMinHeight = viewModel.cardBottomMaxHeight - 150
        
        initBottomCard()
    }
    
    override func configView() {
        initComponent()
        
    }
}

// MARK: - init
extension ArticlesDetailViewController {
    private func initComponent() {
        lblGoTo.textColor = UIColor(hex: 0x6B7280)
        
        imageLoader.loadImageWithUrl(viewModel.articlesModel.backgroundImage)
        
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        viewGoTo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGoTo)))
    }
    
    private func initBottomCard() {
        cardBottomViewController = ArticlesDetailBottomCardViewController(articlesModel: viewModel.articlesModel)
        self.addChild(cardBottomViewController)
        self.view.addSubview(cardBottomViewController.view)
        cardBottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - viewModel.cardBottomMinHeight, width: self.view.bounds.width, height: viewModel.cardBottomMaxHeight)
        cardBottomViewController.view.clipsToBounds = true
        cardBottomViewController.delegate = self
        
        cardBottomViewController.offsetBottom = stackView.frame.size.height
                
        self.view.bringSubviewToFront(stackView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -124, width: stackView.frame.size.width, height: 124)
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0.8).cgColor]
        stackView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - objc
extension ArticlesDetailViewController {
    @objc
    private func tapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapGoTo() {
        Common.showWebLink(viewModel.articlesModel.url)
    }
}

// MARK: - BottomCardViewControllerDelegate
extension ArticlesDetailViewController: ArticlesDetailBottomCardViewControllerDelegate {
    func articlesDetailBottomCardViewControllerDidScroll(offset y: CGFloat) {
        cardBottomViewController.view.frame.origin.y = self.view.frame.height - viewModel.cardBottomMinHeight - y
        
        if cardBottomViewController.view.frame.origin.y <= (viewHeader.frame.origin.y + viewHeader.frame.size.height) {
            cardBottomViewController.view.frame.origin.y = viewHeader.frame.origin.y + viewHeader.frame.size.height
        }
    }
}
