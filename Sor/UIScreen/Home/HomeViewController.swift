//
//  HomeViewController.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 12/09/2024.
//


import UIKit

protocol CalendarViewControllerDeleagte {
  func didSelectDate(dateString: String)
}

enum Constants {
    static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
  static var numOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    static let cycleLength: Int = 28
    static let periodLength: Int = 5
    static let lengthCountDate: Int = 12
}

class HomeViewController: BaseViewController {
  
  // MARK: - Variables & Constants
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBOutlet weak var topMonthButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var dayStack: UIStackView!
  @IBOutlet weak var containerView: UIView!
  
  var currentMonthIndex: Int = 0
     var currentYear: Int = 0
     var presentMonthIndex: Int = 0
     var presentYear: Int = 0
     var todaysDate: Int = 0
     var firstWeekDayOfMonth: Int = 0 // (Sunday-Saturday 1-7)
     var lastCycleStartDate: Date?
  
  var delegate: CalendarViewControllerDeleagte?
  
  // MARK: - UIVIewController Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - UIVIewController helper Methods
  
  override func configView() {
    lastCycleStartDate = DateFormatter.dateFormatter.date(from: "2024-09-3")
    setupViewControllerUI()
    setupCalendar()
  }
  func setupCalendar() {
    currentMonthIndex = Calendar.current.component(.month, from: Date())
    currentMonthIndex -= 1 // bcz apple calendar returns months starting from 1
    
    currentYear = Calendar.current.component(.year, from: Date())
    todaysDate = Calendar.current.component(.day, from: Date())
    firstWeekDayOfMonth = getFirstWeekDay()
    
    //for leap years, make february month of 29 days
    if currentMonthIndex == 1 && currentYear % 4 == 0 {
      Constants.numOfDaysInMonth[currentMonthIndex] = 29
    }
    //end
    presentMonthIndex = currentMonthIndex
    presentYear = currentYear
    
    // display current month name in title
    topMonthButton.setTitle("\(Constants.months[currentMonthIndex]) - \(currentYear)", for: .normal)
  }
  
  func setupViewControllerUI() {
    collectionView.delegate = self
    collectionView.dataSource = self
    topView.layer.cornerRadius = 4
    
    containerView.layer.cornerRadius = 10
    containerView.layer.masksToBounds = true
    containerView.layer.borderColor = UIColor.lightGray.cgColor
    containerView.layer.borderWidth = 0.5
  }
  
  // MARK: - IBActions
  
  @IBAction func leftButtonTapped(_ sender: Any) {
    currentMonthIndex -= 1
    
    if currentMonthIndex < 0 {
      currentMonthIndex = 11
      currentYear -= 1
    }
    
    topMonthButton.setTitle("\(Constants.months[currentMonthIndex]) - \(currentYear)", for: .normal)
    
    //for leap year, make february month of 29 days
    if currentMonthIndex == 1 {
      
      if currentYear % 4 == 0 {
        Constants.numOfDaysInMonth[currentMonthIndex] = 29
        
      } else {
        Constants.numOfDaysInMonth[currentMonthIndex] = 28
      }
    }
    
    firstWeekDayOfMonth = getFirstWeekDay()
    collectionView.reloadData()
  }
  
  @IBAction func rightButtonTapped(_ sender: Any) {
    currentMonthIndex += 1
    
    if currentMonthIndex > 11 {
      currentMonthIndex = 0
      currentYear += 1
    }
    
    topMonthButton.setTitle("\(Constants.months[currentMonthIndex]) - \(currentYear)", for: .normal)
    
    //for leap year, make february month of 29 days
    if currentMonthIndex == 1 {
      
      if currentYear % 4 == 0 {
        Constants.numOfDaysInMonth[currentMonthIndex] = 29
        
      } else {
        Constants.numOfDaysInMonth[currentMonthIndex] = 28
      }
    }
    //end
    firstWeekDayOfMonth = getFirstWeekDay()
    collectionView.reloadData()
  }
  
  
  func getFirstWeekDay() -> Int {
    let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
    //return day == 7 ? 1 : day
    return day
  }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Constants.numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = DateCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
    
    if indexPath.item <= firstWeekDayOfMonth - 2 {
      cell.isHidden = true
      return cell
    }
   
    let calcDate = indexPath.row-firstWeekDayOfMonth+2
    cell.isHidden = false
    cell.dateLabel.text="\(calcDate)"
    
    // If you want to disable the previous dates of current month
    if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
      cell.dateLabel.textColor = .gray
      cell.isUserInteractionEnabled=false
    } else {
      cell.isUserInteractionEnabled=true
    }
    
    guard let date = String.dateFormatter.date(from: "\(currentYear)-\(currentMonthIndex + 1)-\(calcDate)") else {
           return cell
       }
    
    
    if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex  {
      cell.circleView.layer.borderColor = UIColor(hex: "#F08080").cgColor
      cell.dateLabel.textColor = UIColor(hex: "#F08080")
      cell.dateLabel.font = .boldSystemFont(ofSize: 16)
    } else {
      cell.circleView.layer.borderColor = UIColor.clear.cgColor
      if #available(iOS 13.0, *) {
        cell.dateLabel.textColor = .label
      }
      cell.dateLabel.font = .systemFont(ofSize: 16)
    }
    
    if let lastCycleEndDate = lastCycleStartDate {
      let ovulationDates = calculateOvulationDates(for: lastCycleEndDate, cycleLength: Constants.cycleLength, monthsAhead: Constants.lengthCountDate)
      // Tính ngày có kinh nguyệt
      let menstrualDates = calculateMenstrualDates(for: lastCycleEndDate, cycleLength: Constants.cycleLength, monthsAhead: Constants.lengthCountDate)
      // Tính ngày rụng trứng và ngày có khả năng thụ thai cho 10 tháng tới
      let ovulationDatesFertileDays = calculateOvulationAndFertileDays(for: lastCycleEndDate, cycleLength: Constants.cycleLength, monthsAhead: Constants.lengthCountDate)
      
      // Xác định ngày tương ứng trong tháng này
      let currentDate = indexPath.item - firstWeekDayOfMonth + 2
      let dateComponents = DateComponents(year: currentYear, month: currentMonthIndex + 1, day: currentDate)
      
      if let date = Calendar.current.date(from: dateComponents) {
       
        
        if menstrualDates.contains(where: { Calendar.current.isDate(date, inSameDayAs: $0.startDate) ||
          Calendar.current.isDate(date, inSameDayAs: $0.endDate) ||
          (date > $0.startDate && date < $0.endDate) }) {
          cell.circleView.layer.borderColor = UIColor(hex: "#FFC0CB").cgColor
          cell.dateLabel.textColor = UIColor(hex: "#FFC0CB")// Màu cho ngày hành kinh
        }
        if ovulationDatesFertileDays.contains(where: {
          Calendar.current.isDate(date, inSameDayAs: $0.ovulationDate) ||
          $0.fertileDays.contains(where: { Calendar.current.isDate(date, inSameDayAs: $0) })
        }) {
          cell.circleView.layer.borderColor = UIColor(hex: "#DDA0DD").cgColor
          cell.dateLabel.textColor = UIColor(hex: "#DDA0DD")
          // Màu cho ngày có khả năng thụ thai
        }
        
        // Kiểm tra ngày rụng trứng
        if ovulationDates.contains(where: { Calendar.current.isDate(date, inSameDayAs: $0) }) {
          cell.circleView.layer.borderColor = UIColor.clear.cgColor
          cell.eventView.backgroundColor = UIColor(hex: "#D8BFD8")
          cell.dateLabel.textColor = .white
          cell.dateLabel.font = .boldSystemFont(ofSize: 17)
          // Màu cho ngày rụng trứng
        } else {
          cell.eventView.backgroundColor = .clear
        }
      }
      
      if let selectedDate = lastCycleStartDate {
             let calendar = Calendar.current
             let selectedYear = calendar.component(.year, from: selectedDate)
             let selectedMonth = calendar.component(.month, from: selectedDate)
             let selectedDay = calendar.component(.day, from: selectedDate)

             if calcDate == selectedDay && self.currentYear == selectedYear && self.currentMonthIndex + 1 == selectedMonth {
                 cell.circleView.layer.borderColor = UIColor(hex: "#FF69B4").cgColor
                 cell.dateLabel.textColor = UIColor(hex: "#FF69B4")
                 cell.dateLabel.font = .boldSystemFont(ofSize: 16)
             }
         }
    }

    
    
    return cell
  }
  
  // MARK: - UICollectionView Delegate
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
    
    
    if let date = cell?.dateLabel.text! {
      print("\(currentYear)-\(currentMonthIndex+1)-\(date)")
      print("\(todaysDate)")
      
      // If you want to pass the selected date to previous viewController, use following delegate
      self.delegate?.didSelectDate(dateString: "\(currentYear)-\(currentMonthIndex+1)-\(date)")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
    if #available(iOS 13.0, *) {
      cell?.dateLabel.textColor = .label
    }
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/7 , height: collectionView.frame.width/7 )
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}
extension HomeViewController {
  func calculateOvulationDate(from lastCycleEndDate: Date, cycleLength: Int) -> Date {
      // Ngày rụng trứng sẽ là ngày cuối cùng + 14 (giả sử chu kỳ 28 ngày)
      return Calendar.current.date(byAdding: .day, value: 14, to: lastCycleEndDate)!
  }
  
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
  
  func calculateMenstrualDates(for lastCycleEndDate: Date, cycleLength: Int, monthsAhead: Int) -> [(startDate: Date, endDate: Date)] {
      var menstrualDates: [(Date, Date)] = []
      
      // Tính ngày bắt đầu và kết thúc kỳ kinh đầu tiên
    var firstStartDate = lastCycleEndDate // Ngày cuối cùng của chu kỳ
    let firstEndDate = Calendar.current.date(byAdding: .day, value: Constants.periodLength - 1, to: firstStartDate)! // 5 ngày
      menstrualDates.append((firstStartDate, firstEndDate))
      
      // Tính ngày có kinh cho các tháng tiếp theo
    for _ in 1...monthsAhead {
          // Ngày bắt đầu kỳ kinh tiếp theo
          let nextStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: firstStartDate)!
          
          // Ngày kết thúc kỳ kinh tiếp theo
        let nextEndDate = Calendar.current.date(byAdding: .day, value: Constants.periodLength - 1, to: nextStartDate)! // 6 ngày
          menstrualDates.append((nextStartDate, nextEndDate))
          
          // Cập nhật ngày bắt đầu cho lần tiếp theo
          firstStartDate = nextStartDate
      }
      
      return menstrualDates
  }
  
  // có thai
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


}


extension UIColor {
  
  convenience init(hex: String) {
    let r, g, b, a: CGFloat
    
    // Remove the hash if it exists
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexString = hexString.replacingOccurrences(of: "#", with: "")
    
    // Ensure the hex string is 6 or 8 characters long
    if hexString.count == 6 {
      hexString += "FF" // Default alpha value if none provided
    }
    
    if hexString.count == 8 {
      let start = hexString.startIndex
      let rIndex = hexString.index(start, offsetBy: 2)
      let gIndex = hexString.index(start, offsetBy: 4)
      let bIndex = hexString.index(start, offsetBy: 6)
      let aIndex = hexString.index(start, offsetBy: 8)
      
      let rString = String(hexString[start..<rIndex])
      let gString = String(hexString[rIndex..<gIndex])
      let bString = String(hexString[gIndex..<bIndex])
      let aString = String(hexString[bIndex..<aIndex])
      
      var rValue: UInt64 = 0
      var gValue: UInt64 = 0
      var bValue: UInt64 = 0
      var aValue: UInt64 = 0
      
      Scanner(string: rString).scanHexInt64(&rValue)
      Scanner(string: gString).scanHexInt64(&gValue)
      Scanner(string: bString).scanHexInt64(&bValue)
      Scanner(string: aString).scanHexInt64(&aValue)
      
      r = CGFloat(rValue) / 255.0
      g = CGFloat(gValue) / 255.0
      b = CGFloat(bValue) / 255.0
      a = CGFloat(aValue) / 255.0
      
    } else {
      r = 1.0
      g = 1.0
      b = 1.0
      a = 1.0
    }
    
    self.init(red: r, green: g, blue: b, alpha: a)
  }
}

extension DateFormatter {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}
