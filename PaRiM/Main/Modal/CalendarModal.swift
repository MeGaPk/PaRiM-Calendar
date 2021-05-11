//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

protocol CalendarModalDelegate: AnyObject {

}

class CalendarModal {
    weak var delegate: CalendarModalDelegate?

    private var provider: CalendarProvider

    private var dates: [Date] = []
    private var events: [String: [CalendarEvent]] = [:]

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


extension CalendarModal {
    func getDates() -> [Date]? {
        dates
    }

    func getDate(by section: Int) -> Date? {
        dates[section]
    }

    func getEvent(by indexPath: IndexPath) -> CalendarEvent? {
        let date = dates[indexPath.section]
        let dateString = date.toRequestString()
        return events[dateString]?[indexPath.row]
    }

    func getEvents(by section: Int) -> [CalendarEvent]? {
        let date = dates[section]
        let dateString = date.toRequestString()
        return events[dateString]
    }
}