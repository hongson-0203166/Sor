//
//  IngredientsTableViewCell.swift
//  HeartCare
//
//  Created by Admin on 25/06/2024.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupView()
    }
    
    private func setupView() {
//        colorView.roundCorners(topLeft: 3.5, topRight: 3.5, bottomLeft: 3.5, bottomRight: 3.5)
        
//        dataLabel.textColor = R.color.color_353F50()
//        dataLabel.font = R.font.outfitRegular(size: 14)
    }
    
    func setupData(data: String?, color: UIColor?) {
        dataLabel.text = data
        colorView.backgroundColor = color
    }
}
