//
// Created by Иван Гайдамакин on 10.05.2021.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    func toString() -> String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        }
    }
}

class DateCalculation {
    private var calendar = Calendar.current

    private var minDate = Date()
    private var maxDate = Date()

    var duration = 7

    var maxRangeDays = 30 {
        didSet {
            updateMaxRangeDays()
        }
    }

    var currentWeekday: Weekday = .monday {
        didSet {
            updateStartDate()
        }
    }

    private var startDate = Date()

    init() {
        updateMaxRangeDays()
        updateStartDate()
    }

    private func updateMaxRangeDays() {
        minDate = calendar.date(byAdding: .day, value: -maxRangeDays, to: Date())!
        maxDate = calendar.date(byAdding: .day, value: maxRangeDays, to: Date())!
    }

    private func updateStartDate() {
        calendar.firstWeekday = currentWeekday.rawValue
        startDate = calendar.weekBoundary(for: startDate)!.startOfWeek!
    }
}

extension DateCalculation {

    func getWeekDays() -> [Date] {
        var dates = [Date]()
        var days = DateComponents()
        var dayCount = 0
        while true {
            days.day = dayCount
            let date = calendar.date(byAdding: days, to: getFirstDay())!
            if date.compare(getLastDay()) == .orderedDescending {
                break
            }
            dayCount += 1
            dates.append(date)
        }

        return dates
    }

    func getFirstDay() -> Date {
        var startDate = startDate
        if startDate <= minDate {
            startDate = minDate
        }
        return startDate
    }

    func getLastDay() -> Date {
        calendar.weekBoundary(for: startDate)!.endOfWeek!
    }

    func nextWeek() {
        if hasNextWeek() {
            startDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        }
    }

    func previousWeek() {
        if hasPreviousWeek() {
            startDate = calendar.date(byAdding: .day, value: -7, to: startDate)!
        }
    }

    func hasNextWeek() -> Bool {
        startDate <= maxDate
    }

    func hasPreviousWeek() -> Bool {
        startDate >= minDate
    }
}

private extension Calendar {
    /*
    Week boundary is considered the start of
    the first day of the week and the end of
    the last day of the week
    */
    typealias WeekBoundary = (startOfWeek: Date?, endOfWeek: Date?)

    func weekBoundary(for date: Date) -> WeekBoundary? {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)

        guard let startOfWeek = self.date(from: components) else {
            return nil
        }

        let endOfWeekOffset = weekdaySymbols.count - 1
        let endOfWeekComponents = DateComponents(day: endOfWeekOffset, hour: 23, minute: 59, second: 59)
        guard let endOfWeek = self.date(byAdding: endOfWeekComponents, to: startOfWeek) else {
            return nil
        }

        return (startOfWeek, endOfWeek)
    }
}
