//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

class AmazonAPI: CalendarProvider {
    struct Response: Codable {
        enum ErrorReason: String, Codable {
            case invalidDates = "invalid-dates"
            case invalidApiKey = "invalid-api-key"
            case invalidRequest = "invalid-request"
        }

        let error: Bool
        let holidays: [String: [CalendarHolidayDay]]?
        let reason: ErrorReason?
    }

    private static let decoder = Configure(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    private var eventsTask: URLSessionDataTask?

    func getHolidays(from: String, to: String, completion: @escaping (Result<[String: [CalendarHolidayDay]], CustomError>) -> ()) {
        let body: [String: Any] = [
            "apiKey": Bundle.amazonApiKey ?? "",
            "startDate": from,
            "endDate": to,
        ]

        let failureCallback = { (error: CustomError) in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }

        eventsTask?.cancel()
        eventsTask = post(path: "holidays", body: body) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    failureCallback(.emptyData)
                    return
                }
                do {
                    let response = try AmazonAPI.decoder.decode(Response.self, from: data)
                    if response.error {
                        if let reason = response.reason {
                            switch reason {
                            case .invalidDates:
                                failureCallback(.invalidDates)
                            case .invalidApiKey:
                                failureCallback(.invalidApiKey)
                            case .invalidRequest:
                                failureCallback(.invalidRequest)
                            }
                            return
                        }
                        let userInfo = [NSLocalizedDescriptionKey: "Unknown reason error"]
                        failureCallback(.unknown(error: NSError(domain: "in.gaydamak", code: 404, userInfo: userInfo)))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(response.holidays ?? [:]))
                    }
                } catch (let error) {
                    failureCallback(.unknown(error: error))
                }
            case .failure(let error):
                // ignore cancelled request
                if error._code == -999 {
                    return
                }
                failureCallback(.unknown(error: error))
            }
        }
    }

    private func post(path: String, body: [String: Any], completion: @escaping (Result<Data?, Error>) -> ()) -> URLSessionDataTask {
        let baseUrl = Bundle.amazonApiUrl ?? ""
        let url = URL(string: "\(baseUrl)/\(path)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(data))
        })
        task.resume()
        return task
    }
}