//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

protocol CalendarModalDelegate: AnyObject {
    func loaded(dates: [Date], events: [String: [CalendarEvent]])
    func updated(dates: [Date], events: [String: [CalendarEvent]])
}

class CalendarModal {
    weak var delegate: CalendarModalDelegate?

    private let provider: CalendarProvider
    private var bounceTimer: Timer?

    private let storage: CalendarStorage = RealmStorage()

    init(provider: CalendarProvider) {
        self.provider = provider
    }

    public func load(dates: [Date]) {
        storage.getEvents(dates: dates) { [weak self] events, notFoundDates in
            self?.delegate?.loaded(dates: dates, events: events)
            if notFoundDates.count > 0 {
                self?.loadFromProvider(dates: notFoundDates)
            }
        }
    }

    private func loadFromProvider(dates: [Date]) {
        print("load from provider: \(dates)")
        guard let from = dates.first, let to = dates.last else {
            return
        }
        bounceTimer?.invalidate()
        bounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self]timer in
            let fromString = from.toRequestString()
            let toString = to.toRequestString()
            print("REQUEST: \(fromString) -> \(toString)")
            self?.provider.getEvents(from: fromString, to: toString) { [weak self]result in
                switch result {
                case .success(let holidays):
                    print(holidays)
                    self?.storage.save(dates: dates, events: holidays) {
                        self?.storage.getEvents(dates: dates) { [weak self] events, notFoundDates in
                            self?.delegate?.updated(dates: dates, events: events)
                        }
                    }
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        })
    }
}