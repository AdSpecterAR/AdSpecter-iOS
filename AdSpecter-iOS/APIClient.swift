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
//    static let baseURL: String = "https://hidden-everglades-21450.herokuapp.com"
    static let baseURL: String = "http://10.0.0.158:3000"
}
