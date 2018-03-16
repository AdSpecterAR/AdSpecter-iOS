//
//  APIClient.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

public typealias ASRErrorCallback = (Error?) -> Void
public typealias ASRResultCallback = (ASRResult) -> Void
public typealias ASRJSONDictionary = [String: Any]

enum APIClientError: Error {
    case invalidURLPath
    case invalidJSON
    case invalidImpressionID
    case invalidParameters
}

public enum ASRResult {
    case success(ASRJSONDictionary)
    case failure(Error)
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class APIClient {
    // rename to baseURLDevelopment
    private static let baseURLStaging: String = "https://sanchez-staging.herokuapp.com"
    private static let baseURLProduction: String = "https://sanchez-production.herokuapp.com"

    static let baseURL: String = {
        #if DEBUG
            return baseURLStaging
        #else
            return baseURLProduction
        #endif
    }()

    static let shared: APIClient = APIClient()

    private init() { }

    func makeRequest(
        to path: String,
        method: HTTPMethod = .get,
        parameters: ASRJSONDictionary? = nil,
        completion: ASRResultCallback? = nil
    ) {
        guard let url = URL(string: APIClient.baseURL + "/" + path) else {
            completion?(.failure(APIClientError.invalidURLPath))
            return
        }
        makeRequest(to: url, method: method, parameters: parameters, completion: completion)
    }

    private func makeRequest(
        to url: URL,
        method: HTTPMethod = .get,
        parameters: ASRJSONDictionary? = nil,
        completion: ASRResultCallback? = nil
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let parameters = parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
                request.httpBody = data

                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                completion?(.failure(APIClientError.invalidParameters))
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let data = data else {
                completion?(.failure(APIClientError.invalidJSON))
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? ASRJSONDictionary else {
                    completion?(.failure(APIClientError.invalidJSON))
                    return
                }
                completion?(.success(json))
            } catch {
                completion?(.failure(APIClientError.invalidJSON))
            }
        }
        task.resume()
    }
}
