//
//  HeartRateResultCell.swift
//  PulseTrack
//
//  Created by Admin on 23/9/24.
//

import UIKit

class HeartRateResultCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
       // lblTitle.font = R.font.outfitRegular(size: 16)
        lblTitle.textColor = UIColor(hex: 0x243044)
    }
    
    func setupData(text: String) {
        lblTitle.text = text
    }
}
