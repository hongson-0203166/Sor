//
//  NewHeartRateModel.swift
//  HeartCare
//
//  Created by Admin on 9/7/24.
//

import RealmSwift

class NewHeartRateObject: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var createDate: Date = Date()
    @Persisted var bpm: Int = 0
    @Persisted var hrv: Int = 0
    
    convenience init(createDate: Date = Date(), bpm: Int, hrv: Int) {
        self.init()
        self.createDate = createDate
        self.bpm = bpm
        self.hrv = hrv
    }
    
    func toModel() -> NewHeartRateModel {
        return NewHeartRateModel(
            id: id,
            bpm: bpm,
            hrv: hrv,
            createDate: createDate
        )
    }
}

struct NewHeartRateModel: Codable {
    var id: String = ""
    var bpm: Int = 0
    var hrv: Int = 0
    var createDate: Date = Date()
    
    func toObject() -> NewHeartRateObject {
        return NewHeartRateObject(
            createDate: createDate,
            bpm: bpm,
            hrv: hrv
        )
    }
}
