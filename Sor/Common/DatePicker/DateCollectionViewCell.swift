//
//  DateCollectionViewCell.swift
//  PamperMoi
//
//  Created by Umair Afzal on 23/02/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var dateCircularView: UIView!
  @IBOutlet weak var eventView: UIView!
  
  var isFertileDay: Bool = false
  var isPeriodDay: Bool = false
  var isOvulationDay: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    circleView.layer.cornerRadius = circleView.frame.width/2
    circleView.layer.borderWidth = 1
    circleView.layer.borderColor = UIColor.clear.cgColor
    circleView.clipsToBounds = true
    eventView.layer.cornerRadius = circleView.frame.width/2
  }
  
  class func cellForCollectionView(collectionView: UICollectionView, indexPath: IndexPath) -> DateCollectionViewCell {
    let kDateCollectionViewCellIdentifier = "kDateCollectionViewCellIdentifier"
    collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: kDateCollectionViewCellIdentifier)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDateCollectionViewCellIdentifier, for: indexPath) as! DateCollectionViewCell
    return cell
  }
}
