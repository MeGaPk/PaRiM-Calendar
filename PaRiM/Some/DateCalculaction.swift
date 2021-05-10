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
    private let calendar = Calendar.current

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
            updateCurrentDay()
        }
    }

    private var currentDate = Date()

    init() {
        updateMaxRangeDays()
        updateCurrentDay()
    }

    private func updateMaxRangeDays() {
        minDate = calendar.date(byAdding: .day, value: -maxRangeDays, to: Date())!
        maxDate = calendar.date(byAdding: .day, value: maxRangeDays, to: Date())!
    }

    private func updateCurrentDay() {
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: currentDate)
        comps.weekday = currentWeekday.rawValue
        currentDate = calendar.date(from: comps)!
    }
}

extension DateCalculation {

    func getWeekDays() -> [Date] {
        let startDate = getFirstDay()
        let dateEnding = getLastDay()

        var dates = [Date]()
        let components = DateComponents(hour: 0, minute: 0, second: 0) // midnight
        calendar.enumerateDates(startingAfter: startDate, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date {
                if date <= dateEnding {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }

    func getFirstDay() -> Date {
        var startDate = currentDate
        if startDate < minDate {
            startDate = minDate
        }
        return startDate
    }

    func getLastDay() -> Date {
        var dateEnding = calendar.date(byAdding: .day, value: duration, to: getFirstDay())!
        if dateEnding > maxDate {
            dateEnding = maxDate
        }
        return dateEnding
    }

    func nextWeek() {
        if hasNextWeek() {
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        }
    }

    func previousWeek() {
        if hasPreviousWeek() {
            currentDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        }
    }

    func hasNextWeek() -> Bool {
        currentDate <= maxDate
    }

    func hasPreviousWeek() -> Bool {
        currentDate >= minDate
    }
}