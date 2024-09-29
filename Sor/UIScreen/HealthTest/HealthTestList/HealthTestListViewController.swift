//
//  ResizeTable.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

class HealthTestListViewController: BaseViewController {
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var parentAdsView: UIView!
    
    private let viewModel: HealthTestListViewModel
    
    init(data: HeartBlogTestModel) {
        viewModel = HealthTestListViewModel(data: data)
        super.init(nibName: Self.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getData()
        viewModel.onGetDataComplete = { [weak self] in
            guard let `self` = self else {return}
            self.tableView.reloadData()
        }
    }
    
    override func configView() {
//        lblTitle.font = R.font.outfitSemiBold(size: 20)
        lblTitle.text = viewModel.data.title
        
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        
        initTableView()
        
        
    }
    
    
    private func initTableView() {
        tableView.registerCell(HealthTestListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.setHeightForHeader(10)
        tableView.setHeightForFooter()
    }
    
    @objc
    private func tapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HealthTestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.responseData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: HealthTestListCell.self, for: indexPath)
        cell.setupData(data: viewModel.responseData[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HealthTestListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
}

// MARK: - HealthTestListCellDelegate
extension HealthTestListViewController: HealthTestListCellDelegate {
    func healthTestListCellTapNext(data: HealthTestModel) {
        let vc = HealthTestDetailViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
