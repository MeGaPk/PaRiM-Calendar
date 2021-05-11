//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import Foundation

protocol CalendarStorage {
    func getEvents(from: Date, to: Date) -> [String: [CalendarEvent]]
}