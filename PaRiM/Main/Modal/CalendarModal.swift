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
        guard let from = dates.first, let to = dates.last else {
            return
        }
//        TODO: implement load cached on realm events here
        let cachedEvents = storage.getEvents(from: from, to: to)
        delegate?.loaded(dates: dates, events: cachedEvents)

        bounceTimer?.invalidate()
        bounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self]timer in
            let fromString = from.toRequestString()
            let toString = to.toRequestString()
            self?.provider.getEvents(from: fromString, to: toString) { [weak self]result in
                switch result {
                case .success(let holidays):
                    print(holidays)
                    self?.delegate?.updated(dates: dates, events: holidays)
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        })
    }
}