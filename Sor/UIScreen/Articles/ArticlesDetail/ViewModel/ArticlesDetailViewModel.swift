//
//  ArticlesDetailViewModel.swift
//  HeartCare
//
//  Created by Admin on 26/06/2024.
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
