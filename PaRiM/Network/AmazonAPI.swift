//
// Created by Ivan Gaydamakin on 10.05.2021.
//

import Foundation

class AmazonAPI: CalendarProvider {
    private static let decoder = Configure(JSONDecoder()) {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }

    struct Response: Codable {
        enum ErrorReason: String, Codable {
            case invalidDates = "invalid-dates"
            case invalidApiKey = "invalid-api-key"
            case invalidRequest = "invalid-request"
        }

        let error: Bool
        let holidays: [String: [CalendarEvent]]?
        let reason: ErrorReason?
    }

    func getEvents(from: String, to: String, completion: @escaping (Result<[String: [CalendarEvent]], CustomError>) -> ()) {

        let body: [String: Any] = [
            "apiKey": "e4ea80ffb3c3d9fb3cd4bdaa8a1a13e8",
            "startDate": from,
            "endDate": to,
        ]

        let url = URL(string: "https://wozmx9dh26.execute-api.eu-west-1.amazonaws.com/api/holidays")!

        let failureCallback = { (error: CustomError) in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }

        post(url: url, body: body) { result in
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
//                        TODO: implement localizedDescription here
                        failureCallback(.unknown(error: NSError(domain: "in.gaydamak", code: 404, userInfo: nil)))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(response.holidays ?? [:]))
                    }
                } catch (let error) {
                    failureCallback(.unknown(error: error))
                }
            case .failure(let error):
                failureCallback(.unknown(error: error))
            }
        }
    }

    private func post(url: URL, body: [String: Any], completion: @escaping (Result<Data?, Error>) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }).resume()
    }
}