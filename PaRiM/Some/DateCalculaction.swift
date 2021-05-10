//
// Created by Иван Гайдамакин on 10.05.2021.
//

import Foundation

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
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

    func getWeekDays() -> [Date] {
        var startDate = currentDate
        var dateEnding = calendar.date(byAdding: .day, value: duration, to: startDate)!

        if startDate < minDate {
            startDate = minDate
        }

        if dateEnding > maxDate {
            dateEnding = maxDate
        }

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

    func nextWeek() {
        currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
    }

    func previousWeek() {
        currentDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
    }

    func hasNextWeek() -> Bool {
        currentDate < maxDate
    }

    func hasPreviousWeek() -> Bool {
        currentDate <= minDate
    }

//    func daysBetween() {
// Replace the hour (time) of both dates with 00:00
//        let date1 = calendar.startOfDay(for: min)
//        let date2 = calendar.startOfDay(for: secondDate)
//        let components = calendar.dateComponents([.day], from: date1, to: date2)
//    }

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