//
// Created by Иван Гайдамакин on 11.05.2021.
//

import Foundation
import RealmSwift

class CalendarEventRealm: Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var name: String?
    @objc dynamic var type: String?
    @objc dynamic var date = Date()

    override static func primaryKey() -> String? {
        "_id"
    }
}

class RealmStorage {
    private var realm: Realm?

    init() {
        do {
            var config = Realm.Configuration.defaultConfiguration
            config.objectTypes = [CalendarEventRealm.self]
            realm = try Realm(configuration: config)
            // Use realm
        } catch let error as NSError {
            print("Cannot init realm, exception: \(error)")
            // Handle error
        }

    }
}

extension RealmStorage: CalendarStorage {
    func getEvents(from: Date, to: Date) -> [String: [CalendarEvent]] {
        var events = [String: [CalendarEvent]]()

//        for date in from.rangeEveryDay(to: to) {
//            events[date.toRequestString()] = [
//                CalendarEvent(name: "asdasd asdas", type: .folk),
//            ]
//        }
        return events
    }

    func save(dates: [Date], events: [String: [CalendarEvent]]) {
        do {
            try realm?.write {
                // Add the instance to the realm.
                let eventRealm = CalendarEventRealm()
                realm?.add(eventRealm)
            }
        } catch (let error) {
            print("cannot save by error: \(error)")
        }
    }
}