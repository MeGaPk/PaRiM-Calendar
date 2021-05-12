//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import Foundation

protocol CalendarStorage {
    func getEvents(dates: [Date], completion: @escaping (_ cached: [String: [CalendarEvent]], _ needToLoad: [Date]) -> ())
    func save(dates: [Date], events: [String: [CalendarEvent]], completion: @escaping () -> ())
}