//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

protocol CalendarModalDelegate: AnyObject {
    func loaded(dates: [Date], holidays: [String: [CalendarHolidayDay]])
    func updated(dates: [Date], holidays: [String: [CalendarHolidayDay]])
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
        // load cached events
        storage.load(dates: dates) { [weak self] holidays, notFoundDates in
            print("Loaded from storage holidays:\(holidays)")
            // update tableview
            self?.delegate?.loaded(dates: dates, holidays: holidays)
            if notFoundDates.count == 0 {
                return
            }
            print("Detected not cached holidays for dates: \(dates)")
            // request not cached dates
            self?.loadFromProvider(dates: notFoundDates) { holidays in
                print("Loaded from provider holidays:\(holidays)")
                if holidays.count == 0 {
                    return
                }
                // save downloaded holidays
                self?.storage.save(dates: notFoundDates, holidays: holidays) {
                    // load all saved holidays
                    self?.storage.load(dates: dates) { [weak self] events, notFoundDates in
                        // update tableview
                        self?.delegate?.updated(dates: dates, holidays: events)
                    }
                }
            }
        }
    }

    private func loadFromProvider(dates: [Date], completion: @escaping ([String: [CalendarHolidayDay]]) -> ()) {
        guard let from = dates.first, let to = dates.last else {
            return
        }
        // when user click like "crazy" arrow left / right, ignore loading useless data
        bounceTimer?.invalidate()
        bounceTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self]timer in
            let fromString = from.toRequestString()
            let toString = to.toRequestString()
            self?.provider.getHolidays(from: fromString, to: toString) { result in
                switch result {
                case .success(let holidays):
                    completion(holidays)
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        })
    }
}