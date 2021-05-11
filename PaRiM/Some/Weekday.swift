//
// Created by Иван Гайдамакин on 11.05.2021.
//

import Foundation

// like a cache for weekdaySymbols
private var weekdaySymbols: [String] = {
    var calendar = Calendar.current
    calendar.locale = Locale.current
    calendar.firstWeekday = Weekday.sunday.rawValue
    let weekdaySymbols = calendar.weekdaySymbols
    return weekdaySymbols
}()


enum Weekday: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    func toString() -> String {
        weekdaySymbols[self.rawValue - 1]
    }
}