//
//  CalendarTableListController.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/09.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarTableListController: UIViewController {
    private let calendar = FSCalendar()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigation(title: "Calendar")
        setUI()
        configCalendar()
        configTableView()
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
        
        calendar.setCurrentPage(Date(), animated: true)
        calendar.select(Date())
        
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
        
        cell.configData(emotion: .positive)
        return cell
    }
}

extension CalendarTableListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.description(), for: indexPath) as? CalendarTableViewCell else {
            return UITableViewCell()
        }
        cell.configData()
        return cell
    }
}
