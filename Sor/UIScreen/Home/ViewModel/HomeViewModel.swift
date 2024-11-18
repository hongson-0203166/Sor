//
//  HomeViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//

import UIKit

class HomeViewModel {
  var currentMonthIndex: Int = 0
  var currentYear: Int = 0
  var presentMonthIndex: Int = 0
  var presentYear: Int = 0
  var todaysDate: Int = 0
  var firstWeekDayOfMonth: Int = 0 // (Sunday-Saturday 1-7)
  var lastCycleStartDate: Date? {
    DateFormatter.dateFormatter.date(from: "2024-09-3")
  }
  
  func getFirstWeekDay() -> Int {
    let dateString = "\(currentYear)-\(currentMonthIndex + 1)-01"
    
    // Sử dụng DateFormatter để chuyển chuỗi thành Date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = dateFormatter.date(from: dateString) else {
      print("Invalid date format.")
      return 0 // Trả về giá trị mặc định trong trường hợp lỗi
    }
    
    // Lấy ngày đầu tiên của tháng
    let calendar = Calendar.current
    guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
      print("Unable to calculate the first day of the month.")
      return 0
    }
    
    // Lấy ra ngày trong tuần (weekday)
    let day = calendar.component(.weekday, from: firstDayOfMonth)
    
    // Nếu Chủ nhật (7) quy về Thứ hai (1), hoặc giữ nguyên
    return day == 7 ? 1 : day
  }
  
  //Tính toán ngày rụng trứng
  func calculateOvulationDate(from lastCycleEndDate: Date, cycleLength: Int) -> Date {
    // Ngày rụng trứng sẽ là ngày cuối cùng + 14 (giả sử chu kỳ 28 ngày)
    return Calendar.current.date(byAdding: .day, value: HomeModel.cycleLength/2, to: lastCycleEndDate)!
  }
  
  //Tính toán các ngày rụng trứng
  func calculateOvulationDates(for lastCycleEndDate: Date, cycleLength: Int, monthsAhead: Int) -> [Date] {
    var ovulationDates: [Date] = []
    
    // Tính ngày rụng trứng cho tháng hiện tại
    var ovulationDate = calculateOvulationDate(from: lastCycleEndDate, cycleLength: cycleLength)
    ovulationDates.append(ovulationDate)
    
    // Tính ngày rụng trứng cho các tháng tiếp theo
    for _ in 1...monthsAhead {
      if let nextOvulationDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: ovulationDate) {
        ovulationDates.append(nextOvulationDate)
        ovulationDate = nextOvulationDate // Cập nhật ngày rụng trứng
      }
    }
    
    return ovulationDates
  }
  
  //thời gian có kinh nguyệt
  func calculateMenstrualDates(for lastCycleEndDate: Date, cycleLength: Int, monthsAhead: Int) -> [(startDate: Date, endDate: Date)] {
    var menstrualDates: [(Date, Date)] = []
    
    // Tính ngày bắt đầu và kết thúc kỳ kinh đầu tiên
    var firstStartDate = lastCycleEndDate // Ngày cuối cùng của chu kỳ
    let firstEndDate = Calendar.current.date(byAdding: .day, value: HomeModel.periodLength - 1, to: firstStartDate)! // 5 ngày
    menstrualDates.append((firstStartDate, firstEndDate))
    
    // Tính ngày có kinh cho các tháng tiếp theo
    for _ in 1...monthsAhead {
      // Ngày bắt đầu kỳ kinh tiếp theo
      let nextStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: firstStartDate)!
      
      // Ngày kết thúc kỳ kinh tiếp theo
      let nextEndDate = Calendar.current.date(byAdding: .day, value: HomeModel.periodLength - 1, to: nextStartDate)! // 6 ngày
      menstrualDates.append((nextStartDate, nextEndDate))
      
      // Cập nhật ngày bắt đầu cho lần tiếp theo
      firstStartDate = nextStartDate
    }
    
    return menstrualDates
  }
  
  // ngày khả năng có thai
  func calculateOvulationAndFertileDays(for lastCycleEndDate: Date, cycleLength: Int, monthsAhead: Int) -> [(ovulationDate: Date, fertileDays: [Date])] {
    var ovulationDates: [(Date, [Date])] = []
    let calendar = Calendar.current
    
    // Tính ngày rụng trứng cho từng tháng
    for month in 0...monthsAhead {
      // Tính ngày cuối chu kỳ cho tháng hiện tại
      let nextCycleEndDate = calendar.date(byAdding: .day, value: month * cycleLength, to: lastCycleEndDate)!
      
      // Ngày rụng trứng
      let ovulationDate = calendar.date(byAdding: .day, value: cycleLength / 2, to: nextCycleEndDate)!
      
      // Các ngày có khả năng thụ thai
      let fertileDays = [
        ovulationDate,
        calendar.date(byAdding: .day, value: -2, to: ovulationDate)!,
        calendar.date(byAdding: .day, value: -1, to: ovulationDate)!,
        calendar.date(byAdding: .day, value: 1, to: ovulationDate)!,
        calendar.date(byAdding: .day, value: 2, to: ovulationDate)!
      ]
      
      ovulationDates.append((ovulationDate, fertileDays))
    }
    
    return ovulationDates
  }
  
  //thông tin ngày
  func menstruationDateInfor(for date: Date) -> Int? {
    // Ngày hôm nay
    let today = date
    
    // Kiểm tra xem lastCycleStartDate có hợp lệ hay không
    guard let lastCycleStartDate = lastCycleStartDate else {
      return nil
    }
    
    // Tính toán ngày cuối cùng của chu kỳ gần nhất
    let lastCycleEndDate = Calendar.current.date(byAdding: .day, value: HomeModel.cycleLength - 1, to: lastCycleStartDate)!
    
    // Tính số ngày đã trôi qua từ ngày cuối cùng của chu kỳ đến hôm nay
    let daysSinceLastCycleEnd = Calendar.current.dateComponents([.day], from: lastCycleEndDate, to: today).day ?? 0
    
    // Nếu ngày hôm nay là trước ngày bắt đầu chu kỳ mới
    if daysSinceLastCycleEnd < 0 {
      let currentCycleDay = (HomeModel.cycleLength + daysSinceLastCycleEnd) % HomeModel.cycleLength
      return currentCycleDay == 0 ? HomeModel.cycleLength : currentCycleDay
    } else {
      // Tính toán ngày trong chu kỳ hiện tại
      let currentCycleDay = (daysSinceLastCycleEnd % HomeModel.cycleLength)
      return currentCycleDay
    }
  }
  
  // Tính số ngày đến kỳ kinh tiếp theo
  func menstruationDateDetailInfor() -> Int? {
      let today = Date()
      
      guard let lastCycleStartDate = lastCycleStartDate else {
          return nil
      }
      
      var nextPeriodStartDate = lastCycleStartDate
      
      // Lặp qua các chu kỳ cho đến khi tìm thấy ngày bắt đầu kỳ tiếp theo sau hôm nay
      while nextPeriodStartDate <= today {
          nextPeriodStartDate = Calendar.current.date(byAdding: .day, value: HomeModel.cycleLength, to: nextPeriodStartDate)!
      }
      
      // Tính số ngày đến kỳ kinh tiếp theo từ hôm nay
      let daysUntilNextPeriod = Calendar.current.dateComponents([.day], from: today, to: nextPeriodStartDate).day
      
      return daysUntilNextPeriod
  }
}




