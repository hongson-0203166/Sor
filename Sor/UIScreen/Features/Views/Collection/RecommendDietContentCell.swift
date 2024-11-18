//
//  RecommendDietContentCell.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import UIKit

protocol RecommendDietContentCellDelegate: AnyObject {
    func recommendDietContentCellTapNext(data: HeartBlogDietModel)
}

class RecommendDietContentCell: UICollectionViewCell {
    @IBOutlet weak var imageView: ImageLoader!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblCate: UILabel!
    @IBOutlet weak var viewCate: GradientView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblTotalCalo: UILabel!
    @IBOutlet weak var lblCalo: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    
    weak var delegate: RecommendDietContentCellDelegate?
    
    private var data: HeartBlogDietModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        parentView.addShadow()
      lblCate.font = .systemFont(ofSize: 11,weight: .medium)
      viewCate.roundCorners(12)
        viewCate.layer.masksToBounds = true
        
      lblTitle.font = .boldSystemFont(ofSize: 18)
      lblStar.font = .systemFont(ofSize: 14, weight: .semibold)
      lblTotalCalo.font = .systemFont(ofSize: 16, weight: .semibold)
      lblCalo.font = .systemFont(ofSize: 14)
        
        imgNext.isUserInteractionEnabled = true
        imgNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapNext)))
    }
    
    func setupData(data: HeartBlogDietModel) {
        self.data = data
        
        imageView.loadImageWithUrl(data.image)
        lblTitle.text = data.title
        lblStar.text = "\(data.rate ?? 0)/ 5"
        lblTotalCalo.text = "\(data.calo ?? 0)"
        lblCate.text = data.category
    }
    
    @objc
    private func tapNext() {
        guard let data else {return}
        delegate?.recommendDietContentCellTapNext(data: data)
    }
}
