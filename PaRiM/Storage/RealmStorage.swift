//
// Created by Иван Гайдамакин on 11.05.2021.
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

    init() {

    }

    let queue = DispatchQueue(label: "realm.queue")

    private func realm() -> Realm? {
        do {
            var config = Realm.Configuration.defaultConfiguration
            config.objectTypes = [CalendarRealm.self, CalendarEventRealm.self]
            return try Realm(configuration: config)
        } catch let error as NSError {
            print("Cannot init realm, exception: \(error)")
            // Handle error
            return nil
        }
    }

    private func generateEmptyId(by date: Date) -> String {
        "\(date.toRequestString())_\(emptyId())"
    }

    private func emptyId() -> String {
        "empty"
    }
}

extension RealmStorage: CalendarStorage {
    func getEvents(dates: [Date], completion: @escaping (_ cached: [String: [CalendarEvent]], _ needToLoad: [Date]) -> ()) {
        var events = [String: [CalendarEvent]]()

        var needToLoad: [Date] = []

        guard let from = dates.first, let to = dates.last else {
            return
        }
        queue.async { [weak self] in
            self?.realm()?.objects(CalendarRealm.self).filter("date BETWEEN {%@, %@}", from, to).forEach { eventRealm in
                let dateString = eventRealm.date.toRequestString()
                events[dateString] = []
                for event in eventRealm.events {
                    guard let type = EventType(rawValue: event.type) else {
                        return
                    }
                    events[dateString]?.append(CalendarEvent(name: event.name, type: type))
                }
            }
            for date in from.rangeEveryDay(to: to) {
                let dateString = date.toRequestString()

                let event = events[dateString]
                if event == nil {
                    print("NEED TO LOAD: \(dateString)")
                    needToLoad.append(date)
                } else {
                    if let event = event, event.count == 0 {
                        events[dateString] = nil
                    }
                }
            }
            print("CACHE LOADED ", events)
            DispatchQueue.main.async {
                completion(events, needToLoad)
            }
        }
    }

    func save(dates: [Date], events: [String: [CalendarEvent]], completion: @escaping () -> ()) {
        queue.async { [weak self] in
            do {
                let r = self?.realm()
                try r?.write {
                    for date in dates {
                        let calendarRealm = CalendarRealm()
                        calendarRealm.date = date

                        if let events = events[date.toRequestString()] {
                            for event in events {
                                let eventRealm = CalendarEventRealm()
                                eventRealm.name = event.name
                                eventRealm.type = event.type.rawValue
                                calendarRealm.events.append(eventRealm)
                            }
                        }

                        r?.add(calendarRealm, update: .modified)
                        print("write: \(calendarRealm)")
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