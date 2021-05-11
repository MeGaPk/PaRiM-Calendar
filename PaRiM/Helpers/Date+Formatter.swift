//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

private let requestStringFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "yyyy-MM-dd"
}

private let sectionFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "dd.MM EEEE"
}

private let titleFormatter = Configure(DateFormatter()) {
    $0.dateFormat = "dd.MM.yyyy"
}

extension Date {
    func toRequestString() -> String {
        requestStringFormatter.string(from: self)
    }
}

extension Date {
    func toSectionString() -> String {
        sectionFormatter.string(from: self)
    }
}

extension Date {
    func toTitleString() -> String {
        titleFormatter.string(from: self)
    }
}