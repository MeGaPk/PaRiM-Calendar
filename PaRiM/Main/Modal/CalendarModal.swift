//
// Created by Иван Гайдамакин on 10.05.2021.
//

import Foundation

protocol CalendarModalDelegate: AnyObject {

}

class CalendarModal {
    weak var delegate: CalendarModalDelegate?

    private var provider: CalendarProvider

    private(set) var dates: [Date] = []
    private(set) var events: [String: [CalendarEvent]] = [:]

    init(provider: CalendarProvider) {
        self.provider = provider
    }

    public func load(dates: [Date], completion: @escaping () -> ()) {
        guard let from = dates.first?.toRequestString(), let to = dates.last?.toRequestString() else {
            return
        }

        self.dates = dates
        provider.getEvents(from: from, to: to) { [weak self]result in
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