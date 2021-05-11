//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

enum CustomError: Error {
    case emptyData
    case invalidDates
    case invalidApiKey
    case invalidRequest
    case unknown(error: Error)
}

protocol CalendarProvider {
    func getEvents(from: String, to: String, completion: @escaping (Result<[String: [CalendarEvent]], CustomError>) -> ())
}
