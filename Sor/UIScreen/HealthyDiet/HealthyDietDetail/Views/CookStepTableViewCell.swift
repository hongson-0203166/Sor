//
//  CookStepTableViewCell
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

class CookStepTableViewCell: UITableViewCell {
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupView()
    }
    
    private func setupView() {
        numberView.roundCorners(topLeft: 13, topRight: 13, bottomLeft: 13, bottomRight: 13)
        
        numberLabel.textColor = R.color.color_353F50()
//        numberLabel.font = R.font.outfitRegular(size: 14)
        
        contentLabel.textColor = R.color.color_353F50()
//        contentLabel.font = R.font.outfitRegular(size: 14)
    }
    
    func setupData(data: String?, index: Int, isLastItem: Bool) {
        numberLabel.text = String(index + 1)
        contentLabel.text = data
        lineView.isHidden = isLastItem
        bottomLabelConstraint.constant = isLastItem ? 21 : 29
    }
}
