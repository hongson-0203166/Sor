//
//  RecommendTestContentCell.swift
//  HeartCare
//
//  Created by Admin on 21/6/24.
//

import UIKit

protocol RecommendTestContentCellDelegate: AnyObject {
    func recommendTestContentCellTapContent(data: HeartBlogTestModel, indexPath: IndexPath)
}

class RecommendTestContentCell: UICollectionViewCell {
    @IBOutlet weak var imageView: ImageLoader!
    @IBOutlet weak var lblNumberOfTest: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    weak var delegate: RecommendTestContentCellDelegate?
    
    private var data: HeartBlogTestModel?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      lblNumberOfTest.font = .systemFont(ofSize: 20, weight: .medium)
      lblTitle.font = .boldSystemFont(ofSize: 28)
        lblTitle.adjustsFontSizeToFitWidth = true
        layer.cornerRadius = 22
        layer.masksToBounds = true
        
        viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }

    func setupData(data: HeartBlogTestModel?, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
        
        imageView.loadImageWithUrl(data?.imageUrl)
        lblNumberOfTest.text = "\(data?.numberOfCate ?? 0) tests"
        lblTitle.text = data?.title
    }
    
    @objc
    private func tapView() {
        guard let data, let indexPath else {return}
        
        delegate?.recommendTestContentCellTapContent(data: data, indexPath: indexPath)
    }
}
