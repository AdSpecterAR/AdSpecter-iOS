//
//  APIClient.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias ASRErrorCallback = (Error?) -> Void
public typealias ASRJSONDictionary = [String: Any]

enum APIClientError: Error {
    case invalidURL
    case invalidJSON
    case invalidImpressionID
}

class APIClient {
    // rename to baseURLDevelopment
    static let baseURL: String = "https://git.heroku.com/sanchez-dev.git"
    static let baseURLStaging: String = "https://git.heroku.com/sanchez-staging.git"
    static let baseURLProduction: String = "https://git.heroku.com/sanchez-production.git"
}
