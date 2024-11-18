//
//  ArticlesViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 1/10/2024.
//

import UIKit

class ArticlesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var parentAdsView: UIView!
    @IBOutlet weak var adsView: UIView!
    
    private let viewModel = ArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onGetDataComplete = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        viewModel.getData()
    }
    
    override func configView() {
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonPressed)))
        backgroundImageView.image = nil
        backgroundImageView.backgroundColor = UIColor(hex: 0xF2F6FF)
        
        initTableView()
        
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(ArticlesTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}

extension ArticlesViewController {
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ArticlesTableViewCell.self, for: indexPath)
        cell.setupData(title: viewModel.articlesData[indexPath.row].title, image: viewModel.articlesData[indexPath.row].image)
        return cell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        148
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VCService.push(controller: ArticlesDetailViewController(articlesModel: viewModel.articlesData[indexPath.row]))
    }
}
