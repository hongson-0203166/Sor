//
//  HealthTestQuestionViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 23/09/2024.
//

import UIKit

class HealthTestQuestionViewController: BaseViewController {
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblCurrentPage: UILabel!
    @IBOutlet weak var lblDivisor: UILabel!
    @IBOutlet weak var lblTotalPage: UILabel!
    @IBOutlet weak var adsView: UIView!
    
    private let viewModel = HealthTestQuestionViewModel()
    
    init(data: HealthTestModel) {
        viewModel.data = data
        viewModel.totalPage = data.questions?.count ?? 0
        super.init(nibName: Self.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeNextButton(isActive: false, isFinish: false)

        viewModel.onCompleteChangePage = { [weak self] value in
            guard let `self` = self, viewModel.totalPage > 1 else {return}
            
            let isActive = self.viewModel.data?.questions?[value.page].selectedAnswer != nil
            let isFinish = value.page == (viewModel.totalPage - 1)
            
            self.setupCurrentPage(page: value.page + 1)
            self.activeNextButton(isActive: isActive, isFinish: isFinish)
            self.collectionView.scrollToItem(at: IndexPath(item: value.page, section: 0), at: value.type == .increase ? .left : .right, animated: true)
        }
    }
    
    override func configView() {
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBack)))
        
//        btnNext.titleLabel?.font = R.font.outfitSemiBold(size: 18)
        
//        lblCurrentPage.font = R.font.outfitSemiBold(size: 30)
//        lblDivisor.font = R.font.outfitSemiBold(size: 16)
//        lblTotalPage.font = R.font.outfitRegular(size: 16)
        lblTotalPage.text = "\(viewModel.totalPage)"
        setupCurrentPage(page: 1)
        
        initCollectionView()
        
       
    }
    
    private func initCollectionView() {
        collectionView.registerCell(HealthTestQuestionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.isScrollEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    @objc
    private func tapBack() {
        if viewModel.currentPage >= 1 {
            viewModel.reducePage()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        guard viewModel.totalPage > 1 else {return}
        if viewModel.currentPage <= viewModel.totalPage - 2 {
            viewModel.increasePage()
        } else {
            
                pushToResult()
            
        }
    }
    
    @IBAction func btnQuitTapped(_ sender: Any) {
        navigationController?.popTo(type: HealthTestListViewController.self)
    }
}

extension HealthTestQuestionViewController {
    private func activeNextButton(isActive: Bool, isFinish: Bool) {
        btnNext.backgroundColor = isActive ? UIColor(hex: 0xE83E56) : UIColor(hex: 0xE2465C).withAlphaComponent(0.6)
        btnNext.isUserInteractionEnabled = isActive
        
        btnNext.setTitle(!isFinish ? "Next" : "Result", for: .normal)
    }
    
    private func setupCurrentPage(page: Int) {
        if page < 10 {
            lblCurrentPage.text = "0\(page)"
        } else {
            lblCurrentPage.text = "\(page)"
        }
    }
    
    private func pushToResult() {
        guard let data = viewModel.data else {return}
        let vc = HealthTestResultViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HealthTestQuestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalPage
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: HealthTestQuestionCell.self, for: indexPath)
        cell.setupData(data: viewModel.data?.questions?[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HealthTestQuestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
}

// MARK: - HealthTestQuestionCellDelegate
extension HealthTestQuestionViewController: HealthTestQuestionCellDelegate {
    func healthTestQuestionCellDidSelectAnswer(data: HealthTestAnswerModel, indexPath: IndexPath) {
        viewModel.data?.questions?[indexPath.row].selectedAnswer = data
        let isFinish = indexPath.row == (viewModel.totalPage - 1)
        self.activeNextButton(isActive: true, isFinish: isFinish)
    }
}
