//
//  HealthTestQuestionViewModel.swift
//  HeartCare
//
//  Created by Admin on 26/6/24.
//

import Foundation

class HealthTestQuestionViewModel {
    var data: HealthTestModel?
    
    enum StatusType {
        case increase
        case reduce
    }
    
    var statusType: StatusType = .increase
    var currentPage = 0 {
        didSet {
            onCompleteChangePage?((currentPage, statusType))
        }
    }
    var onCompleteChangePage: DynamicBlock<(page: Int, type: StatusType), Void>?
    
    var totalPage = 0
    
    func increasePage() {
        statusType = .increase
        currentPage += 1
    }
    
    func reducePage() {
        statusType = .reduce
        currentPage -= 1
    }
}
