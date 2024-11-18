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

 enum HomeModel {
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
  @IBOutlet weak var circleView: UIView!
  @IBOutlet weak var circleView2: UIView!
  @IBOutlet weak var circleView3: UIView!
  @IBOutlet weak var circleView4: UIView!
  @IBOutlet weak var inforDateView: UIView!
  @IBOutlet weak var inforLargeDateView: UIView!
  @IBOutlet weak var inforDateLable: UILabel!
  @IBOutlet weak var inforDateLargeLable: UILabel!
  
  let viewModel = HomeViewModel()
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

    setupViewControllerUI()
    setupCalendar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupCalendar()
  }
  
  func setupCalendar() {
    viewModel.currentMonthIndex = Calendar.current.component(.month, from: Date())
    viewModel.currentMonthIndex -= 1 // bcz apple calendar returns months starting from 1
    
    viewModel.currentYear = Calendar.current.component(.year, from: Date())
    viewModel.todaysDate = Calendar.current.component(.day, from: Date())
    viewModel.firstWeekDayOfMonth = viewModel.getFirstWeekDay()
    
    //for leap years, make february month of 29 days
    if viewModel.currentMonthIndex == 1 && viewModel.currentYear % 4 == 0 {
      HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] = 29
    }
    //end
    viewModel.presentMonthIndex = viewModel.currentMonthIndex
    viewModel.presentYear = viewModel.currentYear
    
    let inforDateText = "Ngày thứ \(viewModel.menstruationDateInfor(for: Date()) ?? 0) của chu kì kinh nguyệt"
        let attributedString = NSMutableAttributedString(string: inforDateText)

    let range = (inforDateText as NSString).range(of: "\(viewModel.menstruationDateInfor(for: Date()) ?? 0)")

    // Thiết lập thuộc tính in đậm cho phần in đậm
    attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 25), range: range)

    // Gán attributedString vào label
    inforDateLable.attributedText = attributedString
    inforDateLable.textColor = UIColor(hex: 0xEB7377)
    inforDateLargeLable.text = "\(viewModel.menstruationDateDetailInfor() ?? 0) ngày đến kì kinh tiếp theo Ngày xác suất mang thai thấp"
    
    // display current month name in title
    topMonthButton.setTitle("\(HomeModel.months[viewModel.currentMonthIndex]) - \(viewModel.currentYear)", for: .normal)
  }
  
  func setupViewControllerUI() {
    collectionView.delegate = self
    collectionView.dataSource = self
    topView.layer.cornerRadius = 4
    
    containerView.layer.cornerRadius = 10
    containerView.layer.masksToBounds = true
    containerView.layer.borderColor = UIColor.lightGray.cgColor
    containerView.layer.borderWidth = 0.5
    
    circleView.cornorRadius = 6
    circleView2.cornorRadius = 6
    circleView3.cornorRadius = 6
    circleView4.setBorder(width: 1, color: .black, radius: 6)
    
    inforDateView.setBorder(width: 3.5, color: UIColor(hex: 0xEB7377), radius: 12)
    inforLargeDateView.setBorder(width: 2.5, color: UIColor(hex: 0xD3D3D3), radius: 16)
}
  
  // MARK: - IBActions
  
  @IBAction func leftButtonTapped(_ sender: Any) {
    viewModel.currentMonthIndex -= 1
    
    if viewModel.currentMonthIndex < 0 {
      viewModel.currentMonthIndex = 11
      viewModel.currentYear -= 1
    }
    
    topMonthButton.setTitle("\(HomeModel.months[viewModel.currentMonthIndex]) - \(viewModel.currentYear)", for: .normal)
    
    //for leap year, make february month of 29 days
    if viewModel.currentMonthIndex == 1 {
      
      if viewModel.currentYear % 4 == 0 {
        HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] = 29
        
      } else {
        HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] = 28
      }
    }
    
    viewModel.firstWeekDayOfMonth = viewModel.getFirstWeekDay()
    collectionView.reloadData()
  }
  
  @IBAction func rightButtonTapped(_ sender: Any) {
    viewModel.currentMonthIndex += 1
    
    if viewModel.currentMonthIndex > 11 {
      viewModel.currentMonthIndex = 0
      viewModel.currentYear += 1
    }
    
    topMonthButton.setTitle("\(HomeModel.months[viewModel.currentMonthIndex]) - \(viewModel.currentYear)", for: .normal)
    
    //for leap year, make february month of 29 days
    if viewModel.currentMonthIndex == 1 {
      
      if viewModel.currentYear % 4 == 0 {
        HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] = 29
        
      } else {
        HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] = 28
      }
    }
    //end
    viewModel.firstWeekDayOfMonth = viewModel.getFirstWeekDay()
    collectionView.reloadData()
  }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell
    
//    if let date = cell?.dateLabel.text {
//      print("\(viewModel.currentYear)-\(viewModel.currentMonthIndex+1)-\(date)")
//      print("\(viewModel.todaysDate)")
//      
//      // If you want to pass the selected date to previous viewController, use following delegate
//      self.delegate?.didSelectDate(dateString: "\(viewModel.currentYear)-\(viewModel.currentMonthIndex+1)-\(date)")
//    }
  }
}

// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return HomeModel.numOfDaysInMonth[viewModel.currentMonthIndex] + viewModel.firstWeekDayOfMonth - 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = DateCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
    
    if indexPath.item <= viewModel.firstWeekDayOfMonth - 2 {
      cell.isHidden = true
      return cell
    }
   
    let calcDate = indexPath.row-viewModel.firstWeekDayOfMonth+2
    cell.isHidden = false
    cell.dateLabel.text="\(calcDate)"
    
    // If you want to disable the previous dates of current month
    if calcDate < viewModel.todaysDate && viewModel.currentYear == viewModel.presentYear && viewModel.currentMonthIndex == viewModel.presentMonthIndex {
      cell.dateLabel.textColor = .gray
      cell.isUserInteractionEnabled=false
    } else {
      cell.isUserInteractionEnabled=true
    }

    if calcDate == viewModel.todaysDate && viewModel.currentYear == viewModel.presentYear && viewModel.currentMonthIndex == viewModel.presentMonthIndex  {
      cell.circleView.layer.borderColor = UIColor(hex: "#F08080").cgColor
      cell.circleView.backgroundColor = UIColor(hex: "#F08080")
      cell.dateLabel.textColor = .white
      cell.dateLabel.font = .boldSystemFont(ofSize: 16)
    } else {
      cell.circleView.layer.borderColor = UIColor.clear.cgColor
      if #available(iOS 13.0, *) {
        cell.dateLabel.textColor = .label
      }
      cell.circleView.backgroundColor = .clear
      cell.dateLabel.font = .systemFont(ofSize: 16)
    }
    
    if let lastCycleEndDate = viewModel.lastCycleStartDate {
      let ovulationDates = viewModel.calculateOvulationDates(for: lastCycleEndDate, cycleLength: HomeModel.cycleLength, monthsAhead: HomeModel.lengthCountDate)
      // Tính ngày có kinh nguyệt
      let menstrualDates = viewModel.calculateMenstrualDates(for: lastCycleEndDate, cycleLength: HomeModel.cycleLength, monthsAhead: HomeModel.lengthCountDate)
      // Tính ngày rụng trứng và ngày có khả năng thụ thai cho 10 tháng tới
      let ovulationDatesFertileDays = viewModel.calculateOvulationAndFertileDays(for: lastCycleEndDate, cycleLength: HomeModel.cycleLength, monthsAhead: HomeModel.lengthCountDate)
      
      // Xác định ngày tương ứng trong tháng này
      let currentDate = indexPath.item - viewModel.firstWeekDayOfMonth + 2
      let dateComponents = DateComponents(year: viewModel.currentYear, month: viewModel.currentMonthIndex + 1, day: currentDate)
      
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
      
      if let selectedDate = viewModel.lastCycleStartDate {
             let calendar = Calendar.current
             let selectedYear = calendar.component(.year, from: selectedDate)
             let selectedMonth = calendar.component(.month, from: selectedDate)
             let selectedDay = calendar.component(.day, from: selectedDate)

        if calcDate == selectedDay && viewModel.currentYear == selectedYear && viewModel.currentMonthIndex + 1 == selectedMonth {
                 cell.circleView.layer.borderColor = UIColor(hex: "#FF69B4").cgColor
                 cell.dateLabel.textColor = UIColor(hex: "#FF69B4")
                 cell.dateLabel.font = .boldSystemFont(ofSize: 16)
             }
         }
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  
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
