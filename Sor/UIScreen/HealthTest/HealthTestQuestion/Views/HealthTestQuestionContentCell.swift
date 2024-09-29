//
//  HealthTestQuestionContentCell.swift
//  HeartCare
//
//  Created by Admin on 26/6/24.
//

import UIKit

protocol HealthTestQuestionContentCellDelegate: AnyObject {
    func healthTestQuestionContentCellTapContent(data: HealthTestAnswerModel)
}

class HealthTestQuestionContentCell: UITableViewCell {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    
    weak var delegate: HealthTestQuestionContentCellDelegate?
    private var data: HealthTestAnswerModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        parentView.layer.cornerRadius = 8
        parentView.layer.borderWidth = 1
        parentView.layer.borderColor = UIColor(hex: 0xEDEBEB).cgColor
        parentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapContent)))
        
//        lblAnswer.font = R.font.outfitMedium(size: 16)
    }
    
    func setupData(data: HealthTestAnswerModel?, selectedData: HealthTestAnswerModel?) {
        self.data = data
        
        lblAnswer.text = data?.answer
        
        if let selectedData {
            imgSelect.image = data == selectedData ? R.image.ic_checkQues() : R.image.ic_unCheckQues()
        } else {
            imgSelect.image = R.image.ic_unCheckQues()
        }
    }
    
    @objc
    private func tapContent() {
        guard let data else {return}
        delegate?.healthTestQuestionContentCellTapContent(data: data)
    }
}
