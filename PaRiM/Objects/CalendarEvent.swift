//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

enum EventType: String, Codable {
    case folk = "folk"
    case common = "public" // public word is used by Swift
}

struct CalendarEvent: Codable {
    var name: String
    var type: EventType
}

extension CalendarEvent: Hashable {
    var hashValue: Int {
        name.hashValue
    }

    static func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        lhs.name == rhs.name && lhs.type == rhs.type
    }
}