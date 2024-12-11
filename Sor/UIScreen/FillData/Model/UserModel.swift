//
//  UserModel.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 29/11/24.
//
import RealmSwift

class User: Object, RealmEntity {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var cycleLatest = Date()
    @objc dynamic var cycleLength: Int = 28
    @objc dynamic var periodLength: Int = 5
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static var primaryKeyName: String {
        return "id"
    }
}
