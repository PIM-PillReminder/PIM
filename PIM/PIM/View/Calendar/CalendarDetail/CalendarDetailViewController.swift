//
//  CalendarDetailViewController.swift
//  PIM
//
//  Created by Madeline on 9/26/24.
//

import UIKit
import SnapKit

protocol CalendarDetailViewControllerDelegate: AnyObject {
    func calendarDetailViewControllerDidUpdatePillStatus(_ controller: CalendarDetailViewController, date: Date)
}

class CalendarDetailViewController: UIViewController {
    
    private let closeButton = UIButton()
    private let pillStatusImageView = UIImageView()
    private let dateLabel = UILabel()
    private let todayLabel = UILabel()
    private let bottomBackground = UIView()
    private let pillStatusTitleLabel = UILabel()
    private let pillStatusLabel = UILabel()
    // 열고 닫히는 메뉴 버튼들
    private let notTakenRadioButton = UIButton()
    private let takenRadioButton = UIButton()
    private let datePicker = UIDatePicker()
    private let divider = UIView()
    let pillTimeTitleLabel = UILabel()
    let pillTimeLabel = UILabel()
    
    private var modalHeight: CGFloat
    private var selectedDate: Date
    
    var dismissalCompletion: (() -> Void)?
    weak var delegate: CalendarDetailViewControllerDelegate?
    
    private var isTaken = false {
        didSet {
            updateRadioButtonUI()
        }
    }
    
    private var isShowingRadioButtons = true {
        didSet {
            updateUIForSelection()
        }
    }
    
    private var isShowingDatePicker = false {
        didSet {
            updateUIForSelection()
        }
    }
    
    private var isShowingTimePickerSection = false {
        didSet {
            updateUIForSelection()
        }
    }
    
    init(modalHeight: CGFloat, selectedDate: Date) {
        self.modalHeight = modalHeight
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateRadioButtonUI()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        updateDateLabel()
        loadSavedPillTime()
        updatePillStatusImage()
        updateRadioButtonTexts()
        loadUserDefaultPillTime()
    }
    
    private func loadUserDefaultPillTime() {
        let isToday = Calendar.current.isDateInToday(selectedDate)
        
        if isToday {
            // 오늘인 경우 현재 시간으로 설정
            datePicker.date = Date()
            updatePillTimeLabel()
        } else if let defaultPillTime = UserDefaults.standard.object(forKey: "SelectedTime") as? Date {
            // 다른 날짜인 경우 기존 로직대로 설정된 알림 시간 사용
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: defaultPillTime)
            
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            
            if let finalDate = calendar.date(from: components) {
                datePicker.date = finalDate
                updatePillTimeLabel()
            }
        } else {
            // 사용자가 설정한 시간이 없는 경우 오전 9시로 설정
            datePicker.date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: selectedDate) ?? selectedDate
            updatePillTimeLabel()
        }
    }
    
    private func updateRadioButtonTexts() {
        let isToday = Calendar.current.isDateInToday(selectedDate)
        let notTakenText = isToday ? "아직 안 먹었어요" : "안 먹었어요"
        notTakenRadioButton.setTitle("  \(notTakenText)", for: .normal)
        pillStatusLabel.text = isTaken ? "먹었어요" : notTakenText
    }
    
    private func updatePillStatusImage() {
        let isToday = Calendar.current.isDateInToday(selectedDate)
        if isToday && !isTaken {
            pillStatusImageView.image = UIImage(named: "calendar_today")
        } else if !isToday && !isTaken {
            pillStatusImageView.image = UIImage(named: "calendar_notEaten")
        } else {
            pillStatusImageView.image = UIImage(named: "calendar_eaten")
        }
    }
    
    private func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateLabel.text = dateFormatter.string(from: selectedDate)
        
        let calendar = Calendar.current
        todayLabel.isHidden = !calendar.isDateInToday(selectedDate)
    }
    
    @objc private func datePickerValueChanged() {
        updatePillTimeLabel()
        savePillStatus(isPillEaten: true)
    }
    
    private func updatePillTimeLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"
        
        pillTimeLabel.text = formatter.string(from: datePicker.date)
    }
    
    private func savePillStatus(isPillEaten: Bool) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        
        UserDefaultsManager.shared.savePillStatus(date: selectedDate, isPillEaten: isPillEaten)
        
        if isPillEaten {
            var components = calendar.dateComponents([.year, .month, .day], from: startOfDay)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: datePicker.date)
            
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
            
            if let finalDate = calendar.date(from: components) {
                UserDefaults.standard.set(finalDate, forKey: "pillTakenTime_\(startOfDay)")
            }
        } else {
            UserDefaults.standard.removeObject(forKey: "pillTakenTime_\(startOfDay)")
        }
        delegate?.calendarDetailViewControllerDidUpdatePillStatus(self, date: selectedDate)
    }
    
    private func loadSavedPillTime() {
        let status = UserDefaultsManager.shared.getPillStatus()
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        
        if let savedStatus = status[startOfDay] {
            isTaken = savedStatus
            if savedStatus,
               let savedTime = UserDefaults.standard.object(forKey: "pillTakenTime_\(startOfDay)") as? Date {
                datePicker.date = savedTime
                updatePillTimeLabel()
            } else {
                loadUserDefaultPillTime()
            }
        } else {
            isTaken = false
            loadUserDefaultPillTime()
        }
        
        updateRadioButtonTexts()
        isShowingTimePickerSection = isTaken
        updateUIForSelection()
        divider.isHidden = !isTaken
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "gray02")
        view.layer.cornerRadius = 20 // 원하는 반경으로 조절
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        // Close Button
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // Image View
        pillStatusImageView.contentMode = .scaleAspectFit
        pillStatusImageView.image = UIImage(named: "calendar_today")
        view.addSubview(pillStatusImageView)
        
        // Date Label
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dateLabel.textColor = UIColor(named: "black")
        view.addSubview(dateLabel)
        
        todayLabel.text = "오늘"
        todayLabel.font = .boldSystemFont(ofSize: 12)
        todayLabel.textColor = UIColor(named: "white")
        todayLabel.backgroundColor = UIColor(named: "green02")
        todayLabel.layer.cornerRadius = 10
        todayLabel.clipsToBounds = true
        todayLabel.textAlignment = .center
        todayLabel.isHidden = false
        view.addSubview(todayLabel)
        
        // bottom background
        bottomBackground.backgroundColor = UIColor(named: "ExcptWhite10")
        bottomBackground.layer.cornerRadius = 16
        view.addSubview(bottomBackground)
        
        pillStatusTitleLabel.text = "복용 여부"
        pillStatusTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(pillStatusTitleLabel)
        
        pillStatusLabel.text = "아직 안 먹었어요"
        pillStatusLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillStatusLabel.textColor = UIColor(named: "buttonStrokeGreen")
        view.addSubview(pillStatusLabel)
        
        // "아직 안 먹었어요" 라디오 버튼 설정
        notTakenRadioButton.setTitle("  아직 안 먹었어요", for: .normal)
        notTakenRadioButton.setTitleColor(UIColor(named: "buttonStrokeGreen"), for: .normal)
        notTakenRadioButton.setImage(UIImage(named: "radioButton_unselected"), for: .normal)
        notTakenRadioButton.setImage(UIImage(named: "radioButton_selected"), for: .selected)
        notTakenRadioButton.addTarget(self, action: #selector(notTakenSelected), for: .touchUpInside)
        notTakenRadioButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        notTakenRadioButton.isHidden = true
        
        // "먹었어요" 라디오 버튼 설정
        takenRadioButton.setTitle("  먹었어요", for: .normal)
        takenRadioButton.setTitleColor(.lightGray, for: .normal)
        takenRadioButton.setImage(UIImage(named: "radioButton_unselected"), for: .normal)
        takenRadioButton.setImage(UIImage(named: "radioButton_selected"), for: .selected)
        takenRadioButton.addTarget(self, action: #selector(takenSelected), for: .touchUpInside)
        takenRadioButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        takenRadioButton.isHidden = true
        
        view.addSubview(notTakenRadioButton)
        view.addSubview(takenRadioButton)
        
        divider.backgroundColor = UIColor(named: "gray04")
        divider.isHidden = true
        view.addSubview(divider)
        
        let pillTimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(pillTimeTapped))
        pillTimeLabel.addGestureRecognizer(pillTimeTapGesture)
        pillTimeLabel.isUserInteractionEnabled = true
        
        pillTimeTitleLabel.text = "복용 시간"
        pillTimeTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillTimeTitleLabel.isHidden = true
        view.addSubview(pillTimeTitleLabel)
        
        pillTimeLabel.text = "오후 8시 13분"
        pillTimeLabel.textColor = UIColor(named: "buttonStrokeGreen")
        pillTimeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        pillTimeLabel.isHidden = true
        view.addSubview(pillTimeLabel)
        
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.isHidden = true
        datePicker.preferredDatePickerStyle = .wheels
        view.addSubview(datePicker)
        
        let radioButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(radioButtonsTapped))
        bottomBackground.addGestureRecognizer(radioButtonTapGesture)
        bottomBackground.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.trailing.equalToSuperview().inset(18)
            make.width.height.equalTo(24)
        }
        
        pillStatusImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(pillStatusImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        todayLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.top.equalTo(pillStatusImageView.snp.bottom).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        bottomBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(18)
            make.top.equalTo(dateLabel.snp.bottom).offset(32)
            make.height.equalTo(54)
        }
        
        pillStatusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomBackground.snp.top).offset(16)
            make.leading.equalTo(bottomBackground.snp.leading).offset(20)
        }
        
        pillStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomBackground.snp.top).offset(16)
            make.trailing.equalTo(bottomBackground.snp.trailing).inset(20)
        }
        
        notTakenRadioButton.snp.makeConstraints { make in
            make.top.equalTo(pillStatusLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(38)
        }
        
        takenRadioButton.snp.makeConstraints { make in
            make.top.equalTo(notTakenRadioButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(38)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(takenRadioButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(38)
        }
        
        pillTimeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(38)
        }
        
        pillTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(38)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(pillTimeLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    private func updateRadioButtonUI() {
        notTakenRadioButton.isSelected = !isTaken
        takenRadioButton.isSelected = isTaken
        
        notTakenRadioButton.setTitleColor(isTaken ? UIColor(named: "gray07") : UIColor(named: "black"), for: .normal)
        takenRadioButton.setTitleColor(isTaken ? UIColor(named: "black") : UIColor(named: "gray07"), for: .normal)
    }
    
    private func updateUIForSelection() {
        notTakenRadioButton.isHidden = !isShowingRadioButtons
        takenRadioButton.isHidden = !isShowingRadioButtons
        datePicker.isHidden = !isShowingDatePicker
        
        divider.isHidden = !isTaken && !isShowingRadioButtons
        
        var newHeight: CGFloat = 54
        
        if isShowingRadioButtons {
            if isShowingTimePickerSection {
                newHeight = isShowingDatePicker ? 345 : 180
            } else {
                newHeight = 126
            }
        } else if isShowingDatePicker {
            newHeight = 345
        }
        
        UIView.animate(withDuration: 0.3) {
            self.pillTimeTitleLabel.isHidden = !self.isShowingTimePickerSection && !self.isShowingDatePicker
            self.pillTimeLabel.isHidden = !self.isShowingTimePickerSection && !self.isShowingDatePicker
            
            if self.isShowingRadioButtons {
                self.divider.snp.remakeConstraints { make in
                    make.top.equalTo(self.takenRadioButton.snp.bottom).offset(16)
                    make.centerX.equalToSuperview()
                    make.horizontalEdges.equalToSuperview().inset(38)
                    make.height.equalTo(1)
                }
            } else {
                self.divider.snp.remakeConstraints { make in
                    make.top.equalTo(self.pillStatusLabel.snp.bottom).offset(16)
                    make.centerX.equalToSuperview()
                    make.horizontalEdges.equalToSuperview().inset(38)
                    make.height.equalTo(1)
                }
            }
            
            self.bottomBackground.snp.updateConstraints { make in
                make.height.equalTo(newHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func notTakenSelected() {
        isTaken = false
        isShowingTimePickerSection = false
        isShowingDatePicker = false
        updateUIForSelection()
        savePillStatus(isPillEaten: false)
        pillStatusLabel.text = "아직 안 먹었어요"
        updatePillStatusImage()
        updateRadioButtonTexts()
        divider.isHidden = true
    }
    
    @objc private func takenSelected() {
        isTaken = true
        isShowingTimePickerSection = true
        isShowingDatePicker = false
        updateUIForSelection()
        savePillStatus(isPillEaten: true)
        pillStatusLabel.text = "먹었어요"
        updatePillStatusImage()
        updateRadioButtonTexts()
        divider.isHidden = false
    }
    
//    @objc private func dismissModal() {
//        dismiss(animated: true, completion: nil)
    //    }
    
    @objc private func dismissModal() {
        dismiss(animated: true) {
            self.delegate?.calendarDetailViewControllerDidUpdatePillStatus(self, date: self.selectedDate)
            self.dismissalCompletion?()
        }
    }
    
    @objc private func radioButtonsTapped() {
        isShowingRadioButtons = true
        isShowingDatePicker = false
        
        // 라디오 버튼이 다시 나타나면 복용 시간 UI를 아래로 이동
        UIView.animate(withDuration: 0.3) {
            
            self.divider.isHidden = false
            
            self.pillTimeTitleLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.divider.snp.bottom).offset(16)
                make.leading.equalToSuperview().inset(38)
            }
            
            self.pillTimeLabel.snp.remakeConstraints { make in
                make.top.equalTo(self.divider.snp.bottom).offset(16)
                make.trailing.equalToSuperview().inset(38)
            }
            
            self.datePicker.snp.remakeConstraints { make in
                make.top.equalTo(self.pillTimeLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.height.equalTo(150)
            }
            
            self.view.layoutIfNeeded() // 레이아웃 변경 사항 적용
        }
    }
    
    @objc private func pillTimeTapped() {
        isShowingRadioButtons = false
        isShowingDatePicker = true
        updateUIForSelection()
    }
    
    @objc private func dateChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"
        
        let pillTimeLabel = UILabel()
        pillTimeLabel.text = formatter.string(from: datePicker.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preferredContentSize = CGSize(width: view.frame.width, height: modalHeight)
    }
}
