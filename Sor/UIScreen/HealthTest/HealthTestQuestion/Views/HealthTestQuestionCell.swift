//
//  HealthTestQuestionCell.swift
//  HeartCare
//
//  Created by Admin on 26/6/24.
//

import UIKit

protocol HealthTestQuestionCellDelegate: AnyObject {
    func healthTestQuestionCellDidSelectAnswer(data: HealthTestAnswerModel, indexPath: IndexPath)
}

class HealthTestQuestionCell: UICollectionViewCell {
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: HealthTestQuestionCellDelegate?
    private var data: HealthTestQuestionModel?
    private var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblQuestion.font = R.font.outfitMedium(size: 18)
        
        initTableView()
    }
    
    private func initTableView() {
        tableView.registerCell(HealthTestQuestionContentCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 80
        tableView.setHeightForHeader(12)
        tableView.setHeightForFooter()
    }
    
    func setupData(data: HealthTestQuestionModel?, indexPath: IndexPath) {
        self.data = data
        self.indexPath = indexPath
        
        lblQuestion.text = data?.question
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HealthTestQuestionCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.answers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: HealthTestQuestionContentCell.self, for: indexPath)
        cell.setupData(data: data?.answers?[indexPath.row], selectedData: data?.selectedAnswer)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HealthTestQuestionCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - HealthTestQuestionContentCellDelegate
extension HealthTestQuestionCell: HealthTestQuestionContentCellDelegate {
    func healthTestQuestionContentCellTapContent(data: HealthTestAnswerModel) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self, let indexPath else {return}
            
            self.data?.selectedAnswer = data
            self.tableView.reloadData()
            self.delegate?.healthTestQuestionCellDidSelectAnswer(data: data, indexPath: indexPath)
        }
    }
}
