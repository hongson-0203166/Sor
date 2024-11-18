//
//  RecommendArticlesCell.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 30/09/2024.
//

import UIKit

protocol RecommendArticlesCellDelegate: AnyObject {
    func recommendArticlesCellTapContent(data: HeartBlogArticalModel)
    func recommendArticlesCellTapAll()
}

class RecommendArticlesCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var headerView: UIView!
    
    weak var delegate: RecommendArticlesCellDelegate?
    private var datas: [HeartBlogArticalModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      lblTitle.font = .systemFont(ofSize: 18, weight: .medium)
      lblAll.font = .systemFont(ofSize: 14)
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAll)))
        
        initTableView()
    }
    
    func setupData(datas: [HeartBlogArticalModel]) {
        self.datas = datas
        
        heightTableConstraint.constant = CGFloat(datas.count) * 148
        tableView.reloadData()
    }
    
    private func initTableView() {
        tableView.registerCell(RecommendArticlesContentCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.setHeightForFooter()
    }
    
    @objc
    private func tapAll() {
        delegate?.recommendArticlesCellTapAll()
    }
}

// MARK: - UITableViewDataSource
extension RecommendArticlesCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: RecommendArticlesContentCell.self, for: indexPath)
        cell.setupData(data: datas[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RecommendArticlesCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
}

// MARK: - RecommendArticlesContentCellDelegate
extension RecommendArticlesCell: RecommendArticlesContentCellDelegate {
    func recommendArticlesContentCellTapContent(data: HeartBlogArticalModel) {
        delegate?.recommendArticlesCellTapContent(data: data)
    }
}
