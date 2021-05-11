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
