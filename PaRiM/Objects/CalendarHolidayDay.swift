//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

struct CalendarHolidayDay: Codable {
    enum DayType: String, Codable {
        case folk = "folk"
        case common = "public" // public word is used by Swift
    }

    var name: String
    var type: DayType
}

// For Diffable
extension CalendarHolidayDay: Hashable {
    var hashValue: Int {
        name.hashValue
    }

    static func ==(lhs: CalendarHolidayDay, rhs: CalendarHolidayDay) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type
    }
}