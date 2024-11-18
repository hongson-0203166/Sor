//
//  ArticlesDetailViewModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 3/10/2024.
//

import Foundation

class ArticlesDetailViewModel {
    let articlesModel: ArticlesModel
    
    init(articlesModel: ArticlesModel) {
        self.articlesModel = articlesModel
    }
    
    var cardBottomMaxHeight: CGFloat = 0
    var cardBottomMinHeight: CGFloat = 0
}
