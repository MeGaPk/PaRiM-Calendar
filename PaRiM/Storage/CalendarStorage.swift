//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import Foundation

protocol CalendarStorage {
    func load(dates: [Date], completion: @escaping (_ cached: [String: [CalendarHolidayDay]], _ needToLoad: [Date]) -> ())
    func save(dates: [Date], holidays: [String: [CalendarHolidayDay]], completion: @escaping () -> ())
}