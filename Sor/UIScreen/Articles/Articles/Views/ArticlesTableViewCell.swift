//
//  ArticlesTableViewCell.swift
//  HeartCare
//
//  Created by Admin on 26/06/2024.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    @IBOutlet weak var articlesImageView: ImageLoader!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        setupView()
    }
    
    private func setupView() {
        titleLabel.textColor = R.color.color_152238()
//        titleLabel.font = R.font.outfitMedium(size: 18)
        articlesImageView.layer.borderColor = UIColor(hex: 0xEAEAEA).cgColor
        articlesImageView.layer.borderWidth = 1
        articlesImageView.roundCorners(12)
    }
    
    func setupData(title: String, image: String) {
        titleLabel.text = title
        articlesImageView.loadImageWithUrl(image)
    }
}
