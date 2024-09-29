//
//  ResizeTable.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

class HealthyDietViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var breakfastView: UIView!
    @IBOutlet weak var lunchView: UIView!
    @IBOutlet weak var dinnerView: UIView!
    @IBOutlet weak var breakfastImageView: UIImageView!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var lunchImageView: UIImageView!
    @IBOutlet weak var lunchLabel: UILabel!
    @IBOutlet weak var dinnerImageView: UIImageView!
    @IBOutlet weak var dinnerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var parentAdsView: UIView!
    @IBOutlet weak var adsView: UIView!
    
    private let breakfastTableView = UITableView(),
                lunchTableView = UITableView(),
                dinnerTableView = UITableView()
    private var categorySelected = 0
    private let viewModel = HealthyDietViewModel()
    private var categoryViews = [HealthyDietCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        viewModel.onGetDataComplete = { [weak self] in
            guard let `self` = self else {return}
            self.tableView.reloadData()
            self.breakfastTableView.reloadData()
            self.lunchTableView.reloadData()
            self.dinnerTableView.reloadData()
        }
    }
    
    override func configView() {
        setupView()
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension HealthyDietViewController {
    private func setupView() {
        tableView.registerCell(HealthyDietTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.setHeightForFooter(40)
        
        view.addSubview(breakfastTableView)
        breakfastTableView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
        breakfastTableView.registerCell(HealthyDietTableViewCell.self)
        breakfastTableView.delegate = self
        breakfastTableView.dataSource = self
        breakfastTableView.separatorStyle = .none
        breakfastTableView.backgroundColor = .clear
        breakfastTableView.setHeightForFooter(40)
        breakfastTableView.isHidden = true
        
        view.addSubview(lunchTableView)
        lunchTableView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
        lunchTableView.registerCell(HealthyDietTableViewCell.self)
        lunchTableView.delegate = self
        lunchTableView.dataSource = self
        lunchTableView.separatorStyle = .none
        lunchTableView.backgroundColor = .clear
        lunchTableView.setHeightForFooter(40)
        lunchTableView.isHidden = true
        
        view.addSubview(dinnerTableView)
        dinnerTableView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
        dinnerTableView.registerCell(HealthyDietTableViewCell.self)
        dinnerTableView.delegate = self
        dinnerTableView.dataSource = self
        dinnerTableView.separatorStyle = .none
        dinnerTableView.backgroundColor = .clear
        dinnerTableView.setHeightForFooter(40)
        dinnerTableView.isHidden = true
        
//        breakfastView.backgroundColor = R.color.color_E2465C()?.withAlphaComponent(0.05)
        breakfastView.layer.cornerRadius = 18
        let breakfastViewGesture = CustomTapGesture(target: self, action: #selector(categoryViewPressed(_:)))
        breakfastViewGesture.category = .breakfast
        breakfastView.addGestureRecognizer(breakfastViewGesture)
        
//        lunchView.backgroundColor = R.color.color_E2465C()?.withAlphaComponent(0.05)
        lunchView.layer.cornerRadius = 18
        let lunchViewGesture = CustomTapGesture(target: self, action: #selector(categoryViewPressed(_:)))
        lunchViewGesture.category = .lunch
        lunchView.addGestureRecognizer(lunchViewGesture)
        
//        dinnerView.backgroundColor = R.color.color_E2465C()?.withAlphaComponent(0.05)
        dinnerView.layer.cornerRadius = 18
        let dinnerViewGesture = CustomTapGesture(target: self, action: #selector(categoryViewPressed(_:)))
        dinnerViewGesture.category = .dinner
        dinnerView.addGestureRecognizer(dinnerViewGesture)
        
        categoryViews = [
            HealthyDietCategory(category: .breakfast, view: breakfastView, image: breakfastImageView, label: breakfastLabel, tableView: breakfastTableView),
            HealthyDietCategory(category: .lunch, view: lunchView, image: lunchImageView, label: lunchLabel, tableView: lunchTableView),
            HealthyDietCategory(category: .dinner, view: dinnerView, image: dinnerImageView, label: dinnerLabel, tableView: dinnerTableView)
        ]
        
//        breakfastLabel.font = R.font.outfitMedium(size: 14)
//        lunchLabel.font = R.font.outfitMedium(size: 14)
//        dinnerLabel.font = R.font.outfitMedium(size: 14)
//        titleLabel.font = R.font.outfitSemiBold(size: 20)
    }
    
    @objc private func categoryViewPressed(_ sender: CustomTapGesture) {
        tableView.alpha = 0
        updateUICategoryView(categorySelected: sender.category)
    }
    
    private func updateUICategoryView(categorySelected: ReceiptCategory = .all) {
        for item in categoryViews {
          item.view.backgroundColor = item.category == categorySelected ? .red : .red.withAlphaComponent(0.05)
          item.image.setImageColor(color: item.category == categorySelected ? .white : .red)
          item.label.textColor = item.category == categorySelected ? .white : .red
            item.tableView.isHidden = !(item.category == categorySelected)
        }
    }
}

extension HealthyDietViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case breakfastTableView:
            return viewModel.breakfastData.count
        case lunchTableView:
            return viewModel.lunchData.count
        case dinnerTableView:
            return viewModel.dinnerData.count
        default:
            return viewModel.filteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = HealthyDietTableViewCell.loadCell(tableView) as? HealthyDietTableViewCell else {return UITableViewCell()}
        switch tableView {
        case breakfastTableView:
            cell.setupData(data: viewModel.breakfastData[indexPath.row])
        case lunchTableView:
            cell.setupData(data: viewModel.lunchData[indexPath.row])
        case dinnerTableView:
            cell.setupData(data: viewModel.dinnerData[indexPath.row])
        default:
            cell.setupData(data: viewModel.filteredData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case breakfastTableView:
            VCService.push(controller: HealthyDietDetailViewController(receiptModel: viewModel.breakfastData[indexPath.row]))
        case lunchTableView:
            VCService.push(controller: HealthyDietDetailViewController(receiptModel: viewModel.lunchData[indexPath.row]))
        case dinnerTableView:
            VCService.push(controller: HealthyDietDetailViewController(receiptModel: viewModel.dinnerData[indexPath.row]))
        default:
            VCService.push(controller: HealthyDietDetailViewController(receiptModel: viewModel.filteredData[indexPath.row]))
        }
    }
}

class CustomTapGesture: UITapGestureRecognizer {
    var category: ReceiptCategory = .all
}

struct HealthyDietCategory {
    var category: ReceiptCategory
    var view: UIView
    var image: UIImageView
    var label: UILabel
    var tableView: UITableView
}
