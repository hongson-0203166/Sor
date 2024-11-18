//
//  RecommendTestCell.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import UIKit

protocol RecommendTestCellDelegate: AnyObject {
    func recommendTestCellTapContent(data: HeartBlogTestModel, indexPath: IndexPath)
    func recommendTestCellTapWarning()
}

class RecommendTestCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgWarning: UIImageView!
    
    weak var delegate: RecommendTestCellDelegate?
    
    private var datas: [HeartBlogTestModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        lblTitle.font = .systemFont(ofSize: 18, weight: .medium)
        
        initCollectionView()
        imgWarning.isUserInteractionEnabled = true
        imgWarning.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapWarning)))
    }
    
    private func initCollectionView() {
        collectionView.registerCell(RecommendTestContentCell.self)
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
    
    func setupData(datas: [HeartBlogTestModel]) {
        self.datas = datas
        
        collectionView.reloadData()
    }
    
    @objc
    private func tapWarning() {
        delegate?.recommendTestCellTapWarning()
    }
}

// MARK: - UICollectionViewDataSource
extension RecommendTestCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: RecommendTestContentCell.self, for: indexPath)
        cell.setupData(data: datas[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RecommendTestCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 290, height: collectionView.height)
    }
}

// MARK: - RecommendTestContentCellDelegate
extension RecommendTestCell: RecommendTestContentCellDelegate {
    func recommendTestContentCellTapContent(data: HeartBlogTestModel, indexPath: IndexPath) {
        delegate?.recommendTestCellTapContent(data: data, indexPath: indexPath)
    }
}
