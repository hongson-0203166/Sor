//
//  HealthyDietViewModel.swift
//  HeartCare
//
//  Created by Admin on 25/06/2024.
//

import Foundation

class HealthyDietViewModel {
    var onGetDataComplete: VoidBlock?
    var breakfastData = [ReceiptModel](),
        lunchData = [ReceiptModel](),
        dinnerData = [ReceiptModel](),
        receiptData = [ReceiptModel](),
        filteredData = [ReceiptModel]()
    
    func getData() {
        FirebaseService.share.getData(.receipt, type: [ReceiptModel].self) { [weak self] data in
            guard let `self` = self, let data else {return}
            self.receiptData = data
            self.filteredData = data
            self.breakfastData = data.filter { $0.category == ReceiptCategory.breakfast }
            self.lunchData = data.filter { $0.category == ReceiptCategory.lunch }
            self.dinnerData = data.filter { $0.category == ReceiptCategory.dinner }
            self.onGetDataComplete?()
        }
    }
    
    func getListFilterByCategory(category: ReceiptCategory, completion: VoidBlock? = nil) {
        guard category != .all else {
            filteredData = receiptData
            completion?()
            return
        }
        filteredData = receiptData.filter { $0.category == category }
        completion?()
    }
}

