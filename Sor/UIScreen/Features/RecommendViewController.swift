//
//  ChatPDFViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit

class RecommendViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var heightHeaderConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingLabelConstraint: NSLayoutConstraint!
    
    private let viewModel = RecommendViewModel()
    private let articlesViewModel = ArticlesViewModel()
    private let healthyDietViewModel = HealthyDietViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesViewModel.getData()
        healthyDietViewModel.getData()
        viewModel.getData()
        viewModel.onGetDataComplete = { [weak self] in
            guard let `self` = self else {return}
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        }
    
    override func configView() {
        //lblTitle.font = R.font.outfitBold(size: 34)
        
        initTableView()
    }
    
    private func initTableView() {
        tableView.registerCell(RecommendTestCell.self)
        tableView.registerCell(RecommendDietCell.self)
        tableView.registerCell(RecommendArticlesCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 300
        tableView.setHeightForFooter()
    }
}

// MARK: - UITableViewDataSource
extension RecommendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecommendViewModel.CateType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case RecommendViewModel.CateType.test.rawValue:
            let cell = tableView.dequeueCell(with: RecommendTestCell.self, for: indexPath)
            cell.setupData(datas: viewModel.blogData?.tests ?? [])
            cell.delegate = self
            return cell
        case RecommendViewModel.CateType.diet.rawValue:
            let cell = tableView.dequeueCell(with: RecommendDietCell.self, for: indexPath)
            cell.setupData(datas: viewModel.blogData?.diets ?? [])
            cell.delegate = self
            return cell
        case RecommendViewModel.CateType.article.rawValue:
            let cell = tableView.dequeueCell(with: RecommendArticlesCell.self, for: indexPath)
            cell.setupData(datas: viewModel.blogData?.articles ?? [])
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension RecommendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let newLabelY = max(56, 109 - offsetY)
        let fontLabel = max(20, 34 - offsetY)
        
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let `self` = self else {return}
            
            self.heightHeaderConstraint.constant = newLabelY
            
            let newLabelX = min((self.viewHeader.width - self.lblTitle.width) / 2, 24 + offsetY)
            let newLabelY = max((self.viewHeader.height - self.lblTitle.height) / 2, 56 - offsetY)
            self.leadingLabelConstraint.constant = newLabelX
            self.topLabelConstraint.constant = newLabelY
        }
    }
}

// MARK: - RecommendTestCellDelegate
extension RecommendViewController: RecommendTestCellDelegate {
    func recommendTestCellTapContent(data: HeartBlogTestModel, indexPath: IndexPath) {

        let vc = HealthTestListViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func recommendTestCellTapWarning() {
        guard let window = UIWindow.visibleWindow() else {return}
        RecommendTestPermissionView.show(in: window)
    }
}

// MARK: - RecommendDietCellDelegate
extension RecommendViewController: RecommendDietCellDelegate {
    func recommendDietCellTapCell(data: ReceiptModel) {
        VCService.push(controller: HealthyDietDetailViewController(receiptModel: data))
    }
    
    func recommendDietCellTapSeemore() {
        
        VCService.push(controller: HealthyDietViewController())
    }
    
    func recommendDietCellTapNext(data: HeartBlogDietModel) {
        guard let receiptModel = healthyDietViewModel.filteredData.first(where: { $0.name == data.title }) else { return }
        VCService.push(controller: HealthyDietDetailViewController(receiptModel: receiptModel))
    }
}

// MARK: - RecommendArticlesCellDelegate
extension RecommendViewController: RecommendArticlesCellDelegate {
    func recommendArticlesCellTapAll() {
        
        VCService.push(controller: ArticlesViewController())
    }
    
    func recommendArticlesCellTapContent(data: HeartBlogArticalModel) {
        guard let articlesModel = articlesViewModel.articlesData.first(where: {$0.title == data.title}) else { return }
        VCService.push(controller: ArticlesDetailViewController(articlesModel: articlesModel))
    }
}
