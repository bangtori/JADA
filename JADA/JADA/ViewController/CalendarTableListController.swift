//
//  CalendarTableListController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit
import FSCalendar
import FirebaseFirestore

final class CalendarTableListController: UIViewController {
    private let calendar = FSCalendar()
    private let tableView = UITableView()
    private var selectedDate: Date = Date()
    private var monthlyData: [Diary] = [] {
        didSet {
            calendar.reloadData()
        }
    }
    private var selectedData: [Diary] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configDiaryData(date: selectedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "Calendar")
        setUI()
        configCalendar()
        configTableView()
    }
    
    private func loadDiaryDataForMonth(_ date: Date, completion: @escaping () -> Void) {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

        let startTimestamp = startOfMonth.timeIntervalSince1970
        let endTimestamp = endOfMonth.timeIntervalSince1970

        let query = Firestore.firestore().collection("diary")
            .whereField("date", isGreaterThanOrEqualTo: startTimestamp)
            .whereField("date", isLessThan: endTimestamp)
        
        DispatchQueue.global().async {
            query.getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error: 달력 쿼리 가져오기 실패\n\(error)")
                    return
                }
                if let documents = querySnapshot?.documents {
                    if documents.isEmpty {
                        print("document is Empty")
                        
                    } else {
                        var result: [Diary] = []
                        for document in documents {
                            if let temp = try? document.data(as: Diary.self) {
                                result.append(temp)
                            }
                        }
                        monthlyData = result
                        completion()
                    }
                }
            }
        }
    }
    
    private func loadDiaryDataForDate(_ date: Date) {
        selectedData = monthlyData.filter { diary in
            let diaryDate = Date(timeIntervalSince1970: diary.date)
            return Calendar.current.isDate(diaryDate, inSameDayAs: date)
        }
    }
    
    private func configDiaryData(date: Date) {
        loadDiaryDataForMonth(date) { [weak self] in
            guard let self = self else { return }
            loadDiaryDataForDate(date)
        }
    }
    
    private func configTableView() {
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configCalendar() {
        calendar.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.description())
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.setCurrentPage(selectedDate, animated: true)
        calendar.select(selectedDate)
        
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        calendar.appearance.weekdayFont = .jadaBoldBodyFont
        calendar.appearance.titleFont = .jadaCalloutFont
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.placeholderType = .none
        
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleFont = .jadaTitleFont
        calendar.appearance.headerTitleColor = .jadaDarkGreen
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.weekdayTextColor = .jadaDarkGreen
        calendar.appearance.titleTodayColor = .jadaDarkGreen
        calendar.appearance.todayColor = .clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.borderSelectionColor = .clear
        calendar.appearance.titleSelectionColor = .jadaDangerRed
        calendar.appearance.borderRadius = 0
        
    }
    private func setUI() {
        view.addSubViews([calendar, tableView])
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Screen.height * 0.5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CalendarTableListController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCell.description(), for: date, at: position) as? CalendarCell else { return FSCalendarCell() }
        
        let diaries = monthlyData.filter { diary in
                let diaryDate = Date(timeIntervalSince1970: diary.date)
                return Calendar.current.isDate(diaryDate, inSameDayAs: date)
            }
        
        if diaries.isEmpty {
            cell.configData(emotion: nil)
        } else {
            cell.configData(emotion: emotionAverage(diaries))
        }
        
        return cell
    }
    
    private func emotionAverage(_ diaries: [Diary]) -> Emotion {
        let emotionWeight: [Emotion: Double] = [
            .positive: 1.0,
            .neutral: 0.0,
            .negative: -1.0
        ]
        
        let weightedSum = diaries.reduce(0.0) { result, diary in
            guard let weight = emotionWeight[diary.emotion] else {
                return result
            }
            return result + weight
        }
        let averageEmotion = weightedSum / Double(diaries.count)
        
        if averageEmotion > 0.3 {
            return .positive
        } else if averageEmotion > -0.3 {
            return .neutral
        } else {
            return .negative
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        loadDiaryDataForDate(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        loadDiaryDataForMonth(calendar.currentPage) {}
    }
}

extension CalendarTableListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.description(), for: indexPath) as? CalendarTableViewCell else {
            return UITableViewCell()
        }
        cell.configData(diary: selectedData[indexPath.row])
        return cell
    }
}
