//
// Created by Ivan Gaydamakin on 13.05.2021.
//

import Foundation

extension Bundle {
    static var amazonApiUrl: String? {
        Bundle.main.object(forInfoDictionaryKey: "AmazonApiUrl") as? String
    }

    static var amazonApiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "AmazonApiKey") as? String
    }
}