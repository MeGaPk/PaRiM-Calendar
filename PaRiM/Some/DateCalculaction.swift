//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

class DateCalculation {
    private var calendar = Calendar.current
    private var duration = 7

    var firstWeekday: Weekday = .monday {
        didSet {
            updateStartAndEndDate()
        }
    }

    private var startDate = Date()
    private var endDate = Date()

    init() {
        updateStartAndEndDate()
    }

    private func updateStartAndEndDate() {
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: startDate)
        comps.weekday = firstWeekday.rawValue
        startDate = calendar.date(from: comps)!
        endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
    }
}

extension DateCalculation {
    func getWeekDays() -> [Date] {
        var dates = [Date]()
        var days = DateComponents()
        var dayCount = 0
        while true {
            days.day = dayCount
            let date = calendar.date(byAdding: days, to: getFirstDayOfWeek())!
            if date.compare(getLastDayOfWeek()) == .orderedDescending {
                break
            }
            dayCount += 1
            dates.append(date)
        }

        return dates
    }

    func getFirstDayOfWeek() -> Date {
        startDate
    }

    func getLastDayOfWeek() -> Date {
        endDate
    }

    func nextWeek() {
        startDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        updateStartAndEndDate()
    }

    func previousWeek() {
        startDate = calendar.date(byAdding: .day, value: -7, to: startDate)!
        updateStartAndEndDate()
    }
}