//
//  Extension+Tableview.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 15/09/2024.
//

import UIKit

class HealthyDietTableViewCell: BaseTBCell {
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var imageFood: ImageLoader!
    @IBOutlet weak var tagView: GradientView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var caloLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

extension HealthyDietTableViewCell {
    private func setupView() {
        selectionStyle = .none
        backgroundCellView.layer.cornerRadius = 20
        backgroundCellView.addShadow()
        
//        tagView.roundCorners(bottomLeft: 12)
        tagLabel.textColor = .white
//        tagLabel.font = R.font.outfitMedium(size: 11)
        
//        caloLabel.textColor = R.color.color_243044()
//        caloLabel.font = R.font.outfitSemiBold(size: 16)
//        
//        foodLabel.font = R.font.outfitSemiBold(size: 18)
    }
    
    func setupData(data: ReceiptModel) {
        tagLabel.text = data.category?.rawValue
        foodLabel.text = data.name
        caloLabel.text = "\(data.calo ?? 0)"
        rateLabel.text = "\(data.rate ?? 0)/ 5"
        imageFood.loadImageWithUrl(data.image)
    }
}
