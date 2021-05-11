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

    private var provider: CalendarProvider
    private var bounceTimer: Timer?

    init(provider: CalendarProvider) {
        self.provider = provider
    }

    public func load(dates: [Date]) {
        guard let from = dates.first?.toRequestString(), let to = dates.last?.toRequestString() else {
            return
        }

//        TODO: implement load cached on realm events here
        delegate?.loaded(dates: dates, events: [:])

        bounceTimer?.invalidate()
        bounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self]timer in
            self?.provider.getEvents(from: from, to: to) { [weak self]result in
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