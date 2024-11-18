//
//  RecommendArticlesContentCell.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import UIKit

protocol RecommendArticlesContentCellDelegate: AnyObject {
    func recommendArticlesContentCellTapContent(data: HeartBlogArticalModel)
}

class RecommendArticlesContentCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgContent: ImageLoader!
    @IBOutlet weak var viewContent: UIView!
    
    weak var delegate: RecommendArticlesContentCellDelegate?
    private var data: HeartBlogArticalModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      lblTitle.font = .boldSystemFont(ofSize: 18)
        imgContent.layer.cornerRadius = 12
        imgContent.layer.borderWidth = 1
        imgContent.layer.borderColor = UIColor(hex: 0xEAEAEA).cgColor
        imgContent.addShadow()
        
        viewContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    
    func setupData(data: HeartBlogArticalModel) {
        self.data = data
        
        lblTitle.text = data.title
        imgContent.loadImageWithUrl(data.image)
    }
    
    @objc
    private func tapView() {
        guard let data else {return}
        
        delegate?.recommendArticlesContentCellTapContent(data: data)
    }
}
