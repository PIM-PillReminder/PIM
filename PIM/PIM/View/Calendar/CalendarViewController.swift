//
//  CalendarViewController.swift
//  PIM
//
//  Created by Madeline on 2/23/24.
//
import FSCalendar
import SnapKit
import UIKit

class CalendarViewController: UIViewController {
    
    let calendar = FSCalendar()
    let backButton = UIButton()
    let monthLabel = UILabel()
    let infoButton = UIButton()
    let todayButton = UIButton()
    
    private var currentBottomView: UIView? // 현재 보여지고 있는 바텀뷰
    private var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        configureHierarchy()
        configureConstraints()
        configureView()
        checkTodayPillStatus() // 처음 로드될 때 오늘 날짜의 복용 상태와 시간 표시
        
        let today = Date()
        calendar.select(today)
        calendar(calendar, didSelect: today, at: .current)
    }
    
    private func checkTodayPillStatus() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        let today = Date()
        let todayStartOfDay = Calendar.current.startOfDay(for: today)
        
        // UserDefaultsManager에서 오늘 날짜의 pill status를 가져옴
        let pillStatus = UserDefaultsManager.shared.getPillStatus()
        
        // 기존 bottomView 제거
        currentBottomView?.removeFromSuperview()
        
        if pillStatus[todayStartOfDay] == true {
            // 약을 먹은 경우 -> CalendarBottomView로 설정
            let eatenView = CalendarBottomView()
            eatenView.dateLabel.text = dateFormatter.string(from: today)
            eatenView.pillLabel.text = "복용 완료"
            eatenView.pillImageView.image = UIImage(named: "calendar_green")
            
            // 저장된 복용 시간 가져오기
            if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(todayStartOfDay)") as? Date {
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "ko_KR")
                timeFormatter.dateFormat = "a h:mm"
                eatenView.pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
            } else {
                eatenView.pillTakenTimeLabel.text = "복용 기록 없음"
            }
            
            view.addSubview(eatenView)
            eatenView.snp.makeConstraints { make in
                make.top.equalTo(calendar.snp.bottom).offset(20)
                make.horizontalEdges.equalTo(view)
                make.bottom.equalTo(view).offset(32)
            }
            
            currentBottomView = eatenView
        } else {
            // 오늘 약을 먹지 않았거나 복용 여부가 nil인 경우 -> CalendarTodayNotYetBottomView로 설정
            let todayNotYetView = CalendarTodayNotYetBottomView()
            todayNotYetView.dateLabel.text = dateFormatter.string(from: today)
            view.addSubview(todayNotYetView)
            todayNotYetView.snp.makeConstraints { make in
                make.top.equalTo(calendar.snp.bottom).offset(20)
                make.horizontalEdges.equalTo(view)
                make.bottom.equalTo(view).offset(32)
            }
            
            currentBottomView = todayNotYetView
        }
    }
    
    func configureHierarchy() {
        view.addSubview(calendar)
        view.addSubview(backButton)
        view.addSubview(monthLabel)
        view.addSubview(infoButton)
        view.addSubview(todayButton)
    }
    
    func configureConstraints() {
        let topPadding = view.safeAreaInsets.top + 10
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(topPadding)
            make.leading.equalTo(view).offset(3)
            make.centerY.equalTo(monthLabel)
            make.width.height.equalTo(44)
        }
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(topPadding)
            make.centerX.equalTo(view)
        }
        
        infoButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalTo(view).inset(18)
        }
        
        todayButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalTo(infoButton.snp.leading).offset(-18)
        }
        
        let screenHeight = UIScreen.main.bounds.height
        let topInset = screenHeight < 700 ? 0 : 16
        let minCalendarHeight: CGFloat = 500
        let maxCalendarHeight: CGFloat = screenHeight * 0.6
        
        calendar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topInset)
            make.height.greaterThanOrEqualTo(minCalendarHeight)
            make.height.lessThanOrEqualTo(maxCalendarHeight)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func infoButtonTapped() {
        let infoViewController = CalendarInfoViewController()
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        
        infoViewController.view.backgroundColor = UIColor(named: "B")?.withAlphaComponent(0.6)
        
        present(infoViewController, animated: true)
        
        infoViewController.dismissalCompletion = { [weak self] in
            self?.calendar.reloadData()
            if let date = self?.selectedDate {
                self?.updateBottomView(for: date)
            }
        }
    }
    
    func configureView() {
        view.backgroundColor = UIColor(named: "BGWhite")
        view.insetsLayoutMarginsFromSafeArea = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월"
        let title = dateFormatter.string(from: Date())
        
        monthLabel.text = title
        monthLabel.textColor = UIColor(named: "black")
        monthLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        // title3와 동일한 크기의 configuration 생성
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        
        // 이미지 생성 및 설정
        let backImage = UIImage(systemName: "chevron.left")?
            .withConfiguration(config)
            .withTintColor(UIColor(named: "black") ?? .black, renderingMode: .alwaysOriginal)
        
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        infoButton.setImage(UIImage(named: "info"), for: .normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
        configureCalendar()
        
        todayButton.setImage(UIImage(named: "today"), for: .normal)
        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
    }
    
    @objc func todayButtonTapped() {
        let today = Date()
        calendar.select(today)
        calendar.setCurrentPage(today, animated: true)
        calendar(calendar, didSelect: today, at: .current)
    }
}

extension CalendarViewController {
    func configureCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.setCurrentPage(Date(), animated: true)
        calendar.select(Date())
        
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.scope = .month
        
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleDefaultColor = nil  // delegate에서 처리하도록 nil로 설정
        calendar.appearance.titleTodayColor = nil    // delegate에서 처리하도록 nil로 설정
        calendar.appearance.titleWeekendColor = nil
        calendar.appearance.weekdayFont = .systemFont(ofSize: 14, weight: .medium)
        calendar.appearance.weekdayTextColor = UIColor(named: "gray08")
        calendar.appearance.eventDefaultColor = UIColor(named: "primaryGreen")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.weekdayHeight = 60
        calendar.calendarHeaderView.isHidden = true
        calendar.placeholderType = .fillHeadTail
        calendar.scrollDirection = .vertical
        calendar.allowsMultipleSelection = false
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
       guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
       
       cell.clipsToBounds = true
       cell.layer.cornerRadius = 21
       
       let today = Calendar.current.startOfDay(for: Date())
       let startOfDay = Calendar.current.startOfDay(for: date)
       guard let installDate = UserDefaults.standard.object(forKey: "app_install_date") as? Date else { return cell }
       let startOfInstallDay = Calendar.current.startOfDay(for: installDate)
       
       let pillStatus = UserDefaultsManager.shared.getPillStatus()
       
       if startOfDay > today {
           // 미래 날짜는 이미지 없음
           cell.backImageView.image = nil
           
       } else if startOfDay < startOfInstallDay {
           // 앱 설치 이전 날짜
           if let isPillEaten = pillStatus[startOfDay] {
               // 데이터가 있는 경우
               if isPillEaten {
                   cell.backImageView.image = UIImage(named: "calendar_green")
               } else {
                   cell.backImageView.image = UIImage(named: "calendar_red")
               }
           } else {
               // 데이터가 없는 경우 이미지 없음
               cell.backImageView.image = nil
           }
           
       } else {
           // 앱 설치 이후 날짜
           if startOfDay == today {
               // 오늘
               if pillStatus[startOfDay] == true {
                   cell.backImageView.image = UIImage(named: "calendar_green")
               } else {
                   cell.backImageView.image = UIImage(named: "calendar_today")
               }
           } else {
               // 설치 이후의 과거 날짜는 데이터 없으면 안먹은 것으로 처리
               if pillStatus[startOfDay] == true {
                   cell.backImageView.image = UIImage(named: "calendar_green")
               } else {
                   cell.backImageView.image = UIImage(named: "calendar_red")
               }
           }
       }
       
       if position != .current {
           cell.backImageView.alpha = 0.5
       } else {
           cell.backImageView.alpha = 1.0
       }
       
       cell.backImageView.backgroundColor = .clear
       cell.isToday = Calendar.current.isDateInToday(date)
       
       return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDate = date
        updateBottomView(for: date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년 M월"
        let title = dateFormatter.string(from: calendar.currentPage)
        monthLabel.text = title
    }
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date, at position: FSCalendarMonthPosition) -> UIColor? {
        if position == .current {
            // 현재 달에 속하는 날짜는 검정색
            return UIColor(named: "black")
        } else {
            // 이전/다음 달 날짜는 회색
            return UIColor(named: "gray05")
        }
    }
}

extension CalendarViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

extension CalendarViewController: CalendarDetailViewControllerDelegate {
    
    func calendarDetailViewControllerDidUpdatePillStatus(_ controller: CalendarDetailViewController, date: Date) {
        calendar.reloadData()
        checkTodayPillStatus() // 오늘 날짜의 상태를 다시 확인하고 업데이트
        updateBottomView(for: date) // Bottom View 업데이트
    }
    
    func updateBottomView(for date: Date) {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "ko_KR")
       dateFormatter.dateFormat = "M월 d일 EEEE"
       
       let startOfDay = Calendar.current.startOfDay(for: date)
       let pillStatus = UserDefaultsManager.shared.getPillStatus()
       let height = UIScreen.main.bounds.height * 0.27
       
       let today = Calendar.current.startOfDay(for: Date())
       
       // 앱 설치 날짜 가져오기
       guard let installDate = UserDefaults.standard.object(forKey: "app_install_date") as? Date else { return }
       let startOfInstallDay = Calendar.current.startOfDay(for: installDate)
       
       // 기존 bottomView 제거
       currentBottomView?.removeFromSuperview()
       
       // 미래 날짜는 future view 표시
       if startOfDay > today {
           let futureView = CalendarFutureBottomView()
           futureView.updateSelectedDate(newDate: date)
           
           view.addSubview(futureView)
           futureView.snp.makeConstraints { make in
               make.height.equalTo(height)
               make.horizontalEdges.equalTo(view)
               make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
           }
           
           currentBottomView = futureView
           
       } else if startOfDay < startOfInstallDay { // 앱 설치 이전 날짜
           // 먼저 pill status 확인
           if let isPillEaten = pillStatus[startOfDay] {
               // 복용 데이터가 있는 경우
               if isPillEaten {
                   let eatenView = CalendarBottomView()
                   eatenView.selectedDate = date
                   eatenView.updateSelectedDate(newDate: date)
                   eatenView.dateLabel.text = dateFormatter.string(from: date)
                   eatenView.delegate = self
                   
                   if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(startOfDay)") as? Date {
                       let timeFormatter = DateFormatter()
                       timeFormatter.locale = Locale(identifier: "ko_KR")
                       timeFormatter.dateFormat = "a h:mm"
                       eatenView.pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
                   } else {
                       eatenView.pillTakenTimeLabel.text = "복용 기록 없음"
                   }
                   
                   view.addSubview(eatenView)
                   eatenView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = eatenView
                   
               } else {
                   let notEatenView = CalendarNotEatenBottomView()
                   notEatenView.dateLabel.text = dateFormatter.string(from: date)
                   notEatenView.selectedDate = date
                   notEatenView.delegate = self
                   view.addSubview(notEatenView)
                   notEatenView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = notEatenView
               }
           } else {
               // 앱 설치 이전 날짜이고 데이터가 없는 경우에만 NoDataView 표시
               let noDataView = CalendarNoDataBottomView(delegate: self)
               noDataView.updateSelectedDate(newDate: date)
               noDataView.delegate = self
               
               view.addSubview(noDataView)
               noDataView.snp.makeConstraints { make in
                   make.height.equalTo(height)
                   make.horizontalEdges.equalTo(view)
                   make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
               }
               
               currentBottomView = noDataView
           }
           
       } else { // 앱 설치 이후 날짜 (오늘 포함)
           if startOfDay == today {
               if pillStatus[startOfDay] == true {
                   let eatenView = CalendarBottomView()
                   eatenView.selectedDate = date
                   eatenView.updateSelectedDate(newDate: date)
                   eatenView.dateLabel.text = dateFormatter.string(from: date)
                   eatenView.delegate = self
                   
                   if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(startOfDay)") as? Date {
                       let timeFormatter = DateFormatter()
                       timeFormatter.locale = Locale(identifier: "ko_KR")
                       timeFormatter.dateFormat = "a h:mm"
                       eatenView.pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
                   } else {
                       eatenView.pillTakenTimeLabel.text = "복용 기록 없음"
                   }
                   
                   view.addSubview(eatenView)
                   eatenView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = eatenView
                   
               } else {
                   let todayNotYetView = CalendarTodayNotYetBottomView()
                   todayNotYetView.dateLabel.text = dateFormatter.string(from: date)
                   todayNotYetView.selectedDate = date
                   todayNotYetView.delegate = self
                   view.addSubview(todayNotYetView)
                   todayNotYetView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = todayNotYetView
               }
           } else {
               // 앱 설치 이후의 과거 날짜는 데이터 없으면 안먹은 것으로 처리
               if pillStatus[startOfDay] == true {
                   let eatenView = CalendarBottomView()
                   eatenView.selectedDate = date
                   eatenView.updateSelectedDate(newDate: date)
                   eatenView.dateLabel.text = dateFormatter.string(from: date)
                   eatenView.delegate = self
                   
                   if let pillTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(startOfDay)") as? Date {
                       let timeFormatter = DateFormatter()
                       timeFormatter.locale = Locale(identifier: "ko_KR")
                       timeFormatter.dateFormat = "a h:mm"
                       eatenView.pillTakenTimeLabel.text = timeFormatter.string(from: pillTime)
                   } else {
                       eatenView.pillTakenTimeLabel.text = "복용 기록 없음"
                   }
                   
                   view.addSubview(eatenView)
                   eatenView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = eatenView
                   
               } else {
                   let notEatenView = CalendarNotEatenBottomView()
                   notEatenView.dateLabel.text = dateFormatter.string(from: date)
                   notEatenView.selectedDate = date
                   notEatenView.delegate = self
                   view.addSubview(notEatenView)
                   notEatenView.snp.makeConstraints { make in
                       make.height.equalTo(height)
                       make.horizontalEdges.equalTo(view)
                       make.bottom.equalTo(view.safeAreaLayoutGuide).offset(32)
                   }
                   
                   currentBottomView = notEatenView
               }
           }
       }
       
       calendar.reloadData()
    }
}
