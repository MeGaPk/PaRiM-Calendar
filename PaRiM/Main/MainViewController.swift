//
//  ViewController.swift
//  PaRiM
//
//  Created by Иван Гайдамакин on 09.05.2021.
//

import UIKit

class MainViewController: UIViewController {

    private var layoutInstalled = false

    private let calendar = DateCalculation()
    private let presenter = CalenderPresenter()
    private let mainView = MainView()
    private let modal = CalendarModal(provider: AmazonAPI())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view?.backgroundColor = .white
        presenter.tableView = mainView.tableView
        presenter.modal = modal

        mainView.headerView.firstDayButton.addTarget(self, action: #selector(firstDayButtonTapped), for: .touchUpInside)
        mainView.headerView.leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        mainView.headerView.rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)

        updateCalendar()
    }


    @objc func firstDayButtonTapped() {
        WeekdayPicker.show(on: view!, selected: calendar.currentWeekday) { weekday in
            self.calendar.currentWeekday = weekday
            self.updateCalendar()
        }
    }

    @objc func rightArrowTapped() {
        calendar.nextWeek()
        updateCalendar()
    }

    @objc private func leftArrowTapped() {
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

private extension MainViewController {
    private func updateCalendar() {
        updateDates()
        updateTitle()
        updateArrows()
    }

    private func updateArrows() {
        mainView.headerView.leftArrowButton.isEnabled = calendar.hasPreviousWeek()
        mainView.headerView.rightArrowButton.isEnabled = calendar.hasNextWeek()
    }

    private func updateDates() {
        presenter.load(dates: calendar.getWeekDays())
    }

    func updateTitle() {
        let weekday = calendar.currentWeekday
        mainView.headerView.firstDayButton.setTitle("\(weekday.toString())", for: .normal)
        mainView.headerView.titleLabel.text = "\(calendar.getFirstDay().toTitleString()) — \(calendar.getLastDay().toTitleString())"
    }
}
