//
//  HealthTestListCell.swift
//  HeartCare
//
//  Created by Admin on 25/6/24.
//

import UIKit

protocol HealthTestListCellDelegate: AnyObject {
    func healthTestListCellTapNext(data: HealthTestModel)
}

class HealthTestListCell: UITableViewCell {
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumberOfQues: UILabel!
    @IBOutlet weak var imgContent: ImageLoader!
    @IBOutlet weak var parentView: UIView!
    
    weak var delegate: HealthTestListCellDelegate?
    private var data: HealthTestModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        parentView.addShadow()
        
//        lblTitle.font = R.font.outfitMedium(size: 18)
//        lblSubTitle.font = R.font.outfitRegular(size: 12)
//        lblTime.font = R.font.outfitRegular(size: 12)
//        lblNumberOfQues.font = R.font.outfitRegular(size: 12)
        imgContent.layer.cornerRadius = 16
    }
    
    func setupData(data: HealthTestModel) {
        self.data = data
        
        lblTitle.text = data.title
        lblSubTitle.text = data.subTitle
        lblTime.text = "\(Int(data.time ?? 0)) mins"
        lblNumberOfQues.text = "\(data.questions?.count ?? 0) questions"
        imgContent.loadImageWithUrl(data.image)
    }
    
    @IBAction func btnContentTapped(_ sender: Any) {
        guard let data else {return}
        delegate?.healthTestListCellTapNext(data: data)
    }
}
