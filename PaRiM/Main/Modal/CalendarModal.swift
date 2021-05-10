//
// Created by Иван Гайдамакин on 10.05.2021.
//

import Foundation

protocol CalendarModalDelegate: AnyObject {

}

class CalendarModal {
    let calendar = DateCalculation()

    weak var delegate: CalendarModalDelegate?

    private var provider: CalendarProvider

    private(set) var dates: [String] = []
    private(set) var events: [String: [CalendarEvent]] = [:]

    init(provider: CalendarProvider) {
        self.provider = provider
    }

    public func load(completion: @escaping () -> ()) {
        dates = calendar.getWeekDays().map { s in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(identifier: "UTC")
            return formatter.string(from: s)
        }

        provider.getEvents(from: dates.first!, to: dates.last!) { [weak self]result in
            switch result {
            case .success(let holidays):
                print(holidays)
                self?.events = holidays;
            case .failure(let error):
                print("error: \(error)")
            }
            completion()
        }
    }


}