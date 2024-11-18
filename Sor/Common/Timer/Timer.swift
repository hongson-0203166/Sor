//
//  Timer.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/11/24.
//

import Hooks
import Foundation
import Combine

struct TimerS {
    static func useTimer(interval: TimeInterval) -> Date {
      let time = useState(Date())

      useEffect(.preserved(by: interval)) {
          let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
              time.wrappedValue = $0.fireDate
          }

          return {
              timer.invalidate()
          }
      }

      return time.wrappedValue
  }
}
