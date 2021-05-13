//
// Created by Ivan Gaydamakin on 11.05.2021.
//

import Foundation
import RealmSwift

class CalendarEventRealm: Object {
    @objc dynamic var type: String = ""
    @objc dynamic var name: String = ""
}

class CalendarRealm: Object {
    @objc dynamic var _id = ""
    @objc dynamic var date = Date() {
        didSet {
            _id = date.toRequestString()
        }
    }
    let events = List<CalendarEventRealm>()

    override static func primaryKey() -> String? {
        "_id"
    }
}

class RealmStorage {
    let queue = DispatchQueue(label: "realm.queue")

    private func realm() -> Realm? {
        do {
            var config = Realm.Configuration.defaultConfiguration
            config.objectTypes = [CalendarRealm.self, CalendarEventRealm.self]
            return try Realm(configuration: config)
        } catch let error as NSError {
            print("Cannot init realm, exception: \(error)")
            return nil
        }
    }
}

extension RealmStorage: CalendarStorage {
    func load(dates: [Date], completion: @escaping (_ cached: [String: [CalendarHolidayDay]], _ needToLoad: [Date]) -> ()) {
        var events = [String: [CalendarHolidayDay]]()

        var needToLoad: [Date] = []

        guard let from = dates.first, let to = dates.last else {
            return
        }
        queue.async { [weak self] in
            self?.realm()?.objects(CalendarRealm.self).filter("date BETWEEN {%@, %@}", from, to).forEach { eventRealm in
                let dateString = eventRealm.date.toRequestString()
                events[dateString] = []
                for event in eventRealm.events {
                    guard let type = CalendarHolidayDay.DayType(rawValue: event.type) else {
                        return
                    }
                    events[dateString]?.append(CalendarHolidayDay(name: event.name, type: type))
                }
            }
            // For detect "need to load" dates and clean up
            for date in from.rangeEveryDay(to: to) {
                let dateString = date.toRequestString()

                let event = events[dateString]
                if event == nil {
                    needToLoad.append(date)
                } else if events[dateString]?.count ?? 0 == 0 {
                    events[dateString] = nil
                }
            }
            DispatchQueue.main.async {
                completion(events, needToLoad)
            }
        }
    }

    func save(dates: [Date], holidays: [String: [CalendarHolidayDay]], completion: @escaping () -> ()) {
        queue.async { [weak self] in
            do {
                let r = self?.realm()
                try r?.write {
                    for date in dates {
                        let calendarRealm = CalendarRealm()
                        calendarRealm.date = date

                        if let events = holidays[date.toRequestString()] {
                            for event in events {
                                let eventRealm = CalendarEventRealm()
                                eventRealm.name = event.name
                                eventRealm.type = event.type.rawValue
                                calendarRealm.events.append(eventRealm)
                            }
                        }

                        r?.add(calendarRealm, update: .modified)
                    }
                }
            } catch (let error) {
                print("cannot save by error: \(error)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}