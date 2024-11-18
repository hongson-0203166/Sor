//
//  RecommendDietCell.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import UIKit

protocol RecommendDietCellDelegate: AnyObject {
    func recommendDietCellTapSeemore()
    func recommendDietCellTapNext(data: HeartBlogDietModel)
    func recommendDietCellTapCell(data: ReceiptModel)
}

class RecommendDietCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblSeemore: UILabel!
    @IBOutlet weak var viewSeemore: UIView!
    @IBOutlet weak var headerView: UIView!
    
    weak var delegate: RecommendDietCellDelegate?
    
    private var datas: [HeartBlogDietModel] = []
    private let healthyDietViewModel = HealthyDietViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      lblTitle.font = .systemFont(ofSize: 18, weight: .medium)
      lblSeemore.font = .systemFont(ofSize: 14, weight: .light)
        viewSeemore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSeemore)))
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSeemore)))
        initCollectionView()
        healthyDietViewModel.getData()
    }
    
    private func initCollectionView() {
        collectionView.registerCell(RecommendDietContentCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    func setupData(datas: [HeartBlogDietModel]) {
        self.datas = datas
        
        collectionView.reloadData()
    }
    
    @objc
    private func tapSeemore() {
        delegate?.recommendDietCellTapSeemore()
    }
}

// MARK: - UICollectionViewDataSource
extension RecommendDietCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: RecommendDietContentCell.self, for: indexPath)
        cell.setupData(data: datas[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let receiptModel = healthyDietViewModel.filteredData.first(where: { $0.name == datas[indexPath.row].title }) else { return }
        delegate?.recommendDietCellTapCell(data: receiptModel)
    }
}

// MARK: - UICollectionViewDelegate
extension RecommendDietCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 331, height: collectionView.height)
    }
}

// MARK: - RecommendDietContentCellDelegate
extension RecommendDietCell: RecommendDietContentCellDelegate {
    func recommendDietContentCellTapNext(data: HeartBlogDietModel) {
        delegate?.recommendDietCellTapNext(data: data)
    }
}
