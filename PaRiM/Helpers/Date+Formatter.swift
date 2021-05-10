//
// Created by Иван Гайдамакин on 10.05.2021.
//

import Foundation

private let requestStringFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "yyyy-MM-dd"
    $0.timeZone = TimeZone(identifier: "UTC")
}

extension Date {
    func toRequestString() -> String {
        requestStringFormatter.string(from: self)
    }
}

private let sectionFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "dd.MM EEEE"
    $0.timeZone = TimeZone(identifier: "UTC")
}

extension Date {
    func toSectionString() -> String {
        sectionFormatter.string(from: self)
    }
}

private let titleFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "dd.MM.yyyy"
    $0.timeZone = TimeZone(identifier: "UTC")
}

extension Date {
    func toTitleString() -> String {
        titleFormatter.string(from: self)
    }
}