//
//  TabFillDataIndex.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 13/11/24.
//
import SwiftUI

struct FillDataParam {
  var textInput: Binding<String>
  var currentAge : Binding<Int>
  var items: Binding<[Int]>
  var startDate: Binding<Date?>
}

enum TabFillDataIndex: CaseIterable {
  case fill1, fill2, fill3
  
  @ViewBuilder
  func view(_ parameters: FillDataParam) -> some View {
    switch self {
    case .fill1:
      FillData1View(textInput: parameters.textInput)
    case .fill2:
      FillData2View(currentAge: parameters.currentAge, items: parameters.items)
    case .fill3:
        FillData3View(selectedDate: parameters.startDate)
    }
  }
  
  var title: String {
    switch self {
    case .fill1:
      "What’s your name?"
    case .fill2:
      "Your age?"
    case .fill3:
      "The last day of the menstrual cycle?"
    }
  }
}


struct UserModel: Equatable, Codable, Hashable {
    
    enum HeightType: String, CaseIterable, Equatable, Codable {
        case ft = "ft/in"
        case cm
        
        var data: [Int] {
            switch self {
            case .ft:
                Array(1...8)
            case .cm:
                Array(100...270)
            }
        }

        var defaultValue: Int {
            switch self {
            case .ft:
                4
            case .cm:
                151
            }
        }
        
        var defaultIn: Int {
            5
        }
        
        var dataIn: [Int] {
            Array(1...11)
        }
    }

    enum WeightType: String, CaseIterable, Equatable, Codable {
        case lbs
        case kg
        
        var data: [Int] {
            switch self {
            case .lbs:
                Array(20...659)
            case .kg:
                Array(10...300)
            }
        }
        
        var defaultValue: Int {
            switch self {
            case .lbs:
                132
            case .kg:
                60
            }
        }
    }
    
    var name: String = ""
    var gender: String = "Female"
    var age: Int = 30
    var height: Int? = nil
    var weight: Int? = nil
    var `in`: Int = 5
    var heightType: HeightType = .ft
    var weightType: WeightType = .lbs
}

extension UserModel {
    
    var viewStateHeight: String? {
        guard let height else { return nil }
        switch heightType {
        case .ft:
            return height.toString + " ft " + `in`.toString + " in"
        case .cm:
            return height.toString + " " + heightType.rawValue
        }
    }
    
    var viewStateWeight: String? {
        guard let weight else { return nil }
        switch weightType {
        case .lbs:
            return weight.toString + " " + weightType.rawValue
        case .kg:
            return weight.toString + " " + weightType.rawValue
        }
    }
}
