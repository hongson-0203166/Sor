//
//  Userdefault.swift
//  Sor
//
//  Created by Hồng Sơn Phạm on 27/11/24.
//

import Foundation

enum UserDefaultsKey: String {
    case isOnboarding = "isOnboarding"
}

extension UserDefaults {
    var isOnboarding: Bool? {
           get {
               return self.bool(forKey: UserDefaultsKey.isOnboarding.rawValue)
           }
           set {
               self.set(newValue, forKey: UserDefaultsKey.isOnboarding.rawValue)
           }
       }
}

extension UserDefaults {
    func setCodable<T: Codable>(_ value: T, forKey key: String) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(value) {
              self.set(encoded, forKey: key)
          }
      }

      func getCodable<T: Codable>(forKey key: String) -> T? {
          if let data = self.data(forKey: key) {
              let decoder = JSONDecoder()
              if let decoded = try? decoder.decode(T.self, from: data) {
                  return decoded
              }
          }
          return nil
      }
}
