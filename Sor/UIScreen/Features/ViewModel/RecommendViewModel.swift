//
//  RecommendViewModel.swift
//  HeartCare
//
//  Created by Tran Dat on 17/04/2023.
//

import UIKit

class RecommendViewModel {
    enum CateType: Int, CaseIterable {
        case test = 0
        case diet
        case article
    }
    
    var blogData: HeartBlogModel?
    var onGetDataComplete: (() -> Void)?
    
    func getData() {
        FirebaseService.share.getData(.heart_blog, type: HeartBlogModel.self) { [weak self] data in
            guard let `self` = self, let data else {return}
            self.blogData = data
            self.onGetDataComplete?()
        }
    }
}
