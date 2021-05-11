//
// Created by Иван Гайдамакин on 11.05.2021.
//

import Foundation
import RealmSwift

class RealmStorage {

}

extension RealmStorage: CalendarStorage {
    func getEvents(from: Date, to: Date) -> [String: [CalendarEvent]] {
        var events = [String: [CalendarEvent]]()

        for date in from.rangeEveryDay(to: to) {
            events[date.toRequestString()] = [
                CalendarEvent(name: "asdasd asdas", type: .folk),
            ]
        }
        return events
    }
}