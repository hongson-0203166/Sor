//
//  HealthTestListViewModel.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 21/09/2024.
//

import Foundation

class HealthTestListViewModel {
    let data: HeartBlogTestModel
    
    init(data: HeartBlogTestModel) {
        self.data = data
    }
    
    var responseData: [HealthTestModel] = []
    var onGetDataComplete: VoidBlock?
    
    func getData() {
        FirebaseService.share.getData(.health_test_category, type: [HealthTestModel].self) { [weak self] response in
            guard let `self` = self, let response else {return}
            self.responseData = response.filter({ $0.parentId == self.data.id})
            self.onGetDataComplete?()
        }
    }
}
