//
//  ViewController.swift
//  PaRiM
//
//  Created by Ivan Gaydamakin on 09.05.2021.
//

import UIKit

class CalendarViewController: UIViewController {

    private var layoutInstalled = false

    private let calendar = CalendarDateCalculation()
    private let presenter = CalendarTableViewPresenter()
    private let mainView = CalendarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view?.backgroundColor = .appBackgroundColor

        presenter.tableView = mainView.tableView

        mainView.headerView.firstDayButton.addTarget(self, action: #selector(firstDayButtonTapped), for: .touchUpInside)
        mainView.headerView.leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        mainView.headerView.rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)

        updateCalendar()
    }


    @objc func firstDayButtonTapped() {
        WeekdayPicker.show(on: view!, selected: calendar.firstWeekday) { weekday in
            HapticFeedback.button(.selected)
            self.calendar.firstWeekday = weekday
            self.updateCalendar()
        }
    }

    @objc func rightArrowTapped() {
        HapticFeedback.button(.next)
        calendar.nextWeek()
        updateCalendar()
    }

    @objc private func leftArrowTapped() {
        HapticFeedback.button(.previous)
        calendar.previousWeek()
        updateCalendar()
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !layoutInstalled {
            layoutInstalled = true
            mainView.pin(on: view!) {
                [
                    $0.topAnchor.constraint(equalTo: $1.topAnchor),
                    $0.leftAnchor.constraint(equalTo: $1.leftAnchor),
                    $0.rightAnchor.constraint(equalTo: $1.rightAnchor),
                    $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor),
                ]
            }
        }
    }
}

private extension CalendarViewController {
    private func updateCalendar() {
        updateDates()
        updateTitle()
    }

    private func updateDates() {
        presenter.present(dates: calendar.getWeekDays())
    }

    func updateTitle() {
        let weekday = calendar.firstWeekday
        mainView.headerView.firstDayButton.setTitle("\(weekday.toString())", for: .normal)
        mainView.headerView.titleLabel.text = "\(calendar.getFirstDayOfWeek().toTitleString()) — \(calendar.getLastDayOfWeek().toTitleString())"
    }
}
