//
//  ArticlesViewModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 1/10/2024.
//

import Foundation

class ArticlesViewModel {
    private(set) var articlesData = [ArticlesModel]()
    var onGetDataComplete: (() -> Void)?
    
    func getData() {
        FirebaseService.share.getData(.articles, type: [ArticlesModel].self) { [weak self] data in
            guard let `self` = self, let data else {return}
            self.articlesData = data
            self.onGetDataComplete?()
        }
    }
}
