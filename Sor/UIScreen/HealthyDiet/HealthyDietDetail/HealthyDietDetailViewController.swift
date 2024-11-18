//
//  HealthyDietDetailViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 17/09/2024.
//

import UIKit

class HealthyDietDetailViewController: BaseViewController {
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImageView: ImageLoader!
    @IBOutlet weak var caloriesCountLabel: UILabel!
    @IBOutlet weak var timeCostCountLabel: UILabel!
    @IBOutlet weak var serveCountLabel: UILabel!
    @IBOutlet weak var proteinCountLabel: UILabel!
    @IBOutlet weak var sodiumCountLabel: UILabel!
    @IBOutlet weak var fatCountLabel: UILabel!
    @IBOutlet weak var sugarCountLabel: UILabel!
    @IBOutlet weak var tagView: GradientView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var nutritionView: UIView!
    @IBOutlet weak var ingredientsTableView: AutoReSizeTableView!
    @IBOutlet weak var cookStepTableView: AutoReSizeTableView!
    @IBOutlet weak var linkReferenceButton: UIButton!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var parentAdsView: UIView!
    @IBOutlet weak var adsView: UIView!
    
    private let viewModel = HealthyDietDetailViewModel()
    private let receiptModel: ReceiptModel
    
    init(receiptModel: ReceiptModel) {
        self.receiptModel = receiptModel
        super.init(nibName: HealthyDietDetailViewController.name, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ingredientsTableView.roundCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
        cookStepTableView.roundCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
        nutritionView.roundCorners(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
    }
    
    override func configView() {
        setupView()
        tagView.roundCorners(topLeft: 12, topRight: 12, bottomLeft: 12, bottomRight: 12)
        
    }
    
    override func setupObservable() {
        linkReferenceButton.publisher(for: .touchUpInside).sink { [weak self] _ in
            guard let `self` = self else {return}
            Common.showWebLink(self.receiptModel.sources ?? "")
        }.store(in: &cancelable)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension HealthyDietDetailViewController {
    private func setupView() {
        let hostUrl = viewModel.getHostLink(receiptModel.sources)
      linkReferenceButton.setAttributedTitle(NSMutableAttributedString().customFont(hostUrl, font: .italicSystemFont(ofSize: 12)).setColor(.black, range: hostUrl).underlined(), for: .normal)
        referenceLabel.text = "Reference" + ": "
        
        foodImageView.loadImageWithUrl(receiptModel.image)
        
        foodLabel.text = receiptModel.name
        foodLabel.textColor = R.color.color_152238()
        foodLabel.numberOfLines = 0
        
        tagLabel.text = receiptModel.category?.rawValue
        tagLabel.textColor = .white
        
        caloriesCountLabel.text = String(receiptModel.calo ?? 0)
        caloriesCountLabel.textColor = R.color.color_243044()
        
        timeCostCountLabel.text = String(receiptModel.timeCost ?? 0)
        timeCostCountLabel.textColor = R.color.color_243044()
        
        serveCountLabel.text = String(receiptModel.serve ?? 0)
        serveCountLabel.textColor = R.color.color_243044()
        
        proteinCountLabel.text = "\(receiptModel.protein ?? 0) g"
        proteinCountLabel.textColor = R.color.color_243044()
//        proteinCountLabel.font = R.font.outfitMedium(size: 16)
        
        sodiumCountLabel.text = "\(receiptModel.sodium ?? 0) mg"
        sodiumCountLabel.textColor = R.color.color_243044()
//        sodiumCountLabel.font = R.font.outfitMedium(size: 16)
        
        fatCountLabel.text = "\(receiptModel.fat ?? 0) g"
        fatCountLabel.textColor = R.color.color_243044()
//        fatCountLabel.font = R.font.outfitMedium(size: 16)
        
        sugarCountLabel.text = "\(receiptModel.sugar ?? 0) g"
        sugarCountLabel.textColor = R.color.color_243044()
//        sugarCountLabel.font = R.font.outfitMedium(size: 16)
        
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.registerCell(IngredientsTableViewCell.self)
        ingredientsTableView.separatorStyle = .none
        ingredientsTableView.estimatedRowHeight = 50
        ingredientsTableView.setHeightForFooter(12)
        ingredientsTableView.isScrollEnabled = false
        
        cookStepTableView.delegate = self
        cookStepTableView.dataSource = self
        cookStepTableView.registerCell(CookStepTableViewCell.self)
        cookStepTableView.separatorStyle = .none
        cookStepTableView.estimatedRowHeight = 50
        cookStepTableView.setHeightForFooter()
        cookStepTableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: cookStepTableView.width, height: 12))
        cookStepTableView.isScrollEnabled = false
    }
}

extension HealthyDietDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ingredientsTableView:
            return receiptModel.ingres?.count ?? 0
        case cookStepTableView:
            return receiptModel.cooks?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case ingredientsTableView:
            let cell = tableView.dequeueCell(with: IngredientsTableViewCell.self, for: indexPath)
            cell.setupData(data: receiptModel.ingres?[indexPath.row], color: viewModel.ingredientsColor[indexPath.row % viewModel.ingredientsColor.count])
            return cell
        case cookStepTableView:
            let cell = tableView.dequeueCell(with: CookStepTableViewCell.self, for: indexPath)
            cell.setupData(data: receiptModel.cooks?[indexPath.row], index: indexPath.row, isLastItem: indexPath.row == (receiptModel.cooks ?? []).count - 1)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case ingredientsTableView:
            return UITableView.automaticDimension
        case cookStepTableView:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}
