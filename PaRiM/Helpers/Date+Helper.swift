//
// Created by Иван Гайдамакин on 11.05.2021.
//

import Foundation

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        self + n
    }

    func rangeEveryDay(to date: Date) -> StrideTo<Date> {
        let dayDurationInSeconds: TimeInterval = 60 * 60 * 24

        var days = DateComponents()
        days.day = 1

        let date = Calendar.current.date(byAdding: days, to: date)!
        return stride(from: self, to: date, by: dayDurationInSeconds)
    }
}