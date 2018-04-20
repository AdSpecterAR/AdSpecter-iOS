//
//  APIClient.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

public typealias ASRErrorCallback = (Error?) -> Void
public typealias ASRResultCallback<T> = (ASRResult<T>) -> Void
public typealias ASRJSONDictionary = [String: Any]

enum APIClientError: Error {
    case invalidURLPath
    case invalidJSON
    case invalidImpressionID
    case invalidParameters
    case missingDeveloperKey
}

public enum ASRResult<T> {
    case success(T)
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
    struct URLRequestHolder {
        let url: URL
        let method: HTTPMethod
        let parameters: ASRJSONDictionary?
        let completion: ASRResultCallback<ASRJSONDictionary>?
    }

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

    var developerKey: String?
    var appSessionID: String? {
        didSet {
            guard let appSessionID = appSessionID, appSessionID != oldValue else {
                return
            }
            urlRequestsWaitingForAuthentication.forEach { holder in
                makeRequest(holder)
            }
            urlRequestsWaitingForAuthentication.removeAll()
        }
    }

    private var urlRequestsWaitingForAuthentication: [URLRequestHolder] = []

    private init() { }

    func makeRequest(
        to path: String,
        method: HTTPMethod = .get,
        parameters: ASRJSONDictionary? = nil,
        completion: ASRResultCallback<ASRJSONDictionary>? = nil
    ) {
        guard let url = URL(string: APIClient.baseURL + "/" + path) else {
            completion?(.failure(APIClientError.invalidURLPath))
            return
        }
        makeRequest(
            to: url,
            method: method,
            parameters: parameters,
            completion: completion
        )
    }

    private func makeRequest(
        to url: URL,
        method: HTTPMethod = .get,
        parameters: ASRJSONDictionary? = nil,
        completion: ASRResultCallback<ASRJSONDictionary>? = nil
    ) {
        let holder = URLRequestHolder(
            url: url,
            method: method,
            parameters: parameters,
            completion: completion
        )
        if url.path.contains("authenticate") == true || url.path.contains("ad_units") || appSessionID != nil {
            makeRequest(holder)
        } else {
            urlRequestsWaitingForAuthentication.append(holder)
        }
    }

    private func makeRequest(_ holder: URLRequestHolder) {
        var request = URLRequest(url: holder.url)
        request.httpMethod = holder.method.rawValue

        var parameters: ASRJSONDictionary = holder.parameters ?? [:]
        guard let developerKey = developerKey else {
            holder.completion?(.failure(APIClientError.missingDeveloperKey))
            return
        }
        parameters["developer_key"] = developerKey

        if let sessionID = AdSpecter.shared.adManager.sessionID {
            parameters["app_session_id"] = sessionID
        }

        if !parameters.isEmpty && holder.method != .get {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
                request.httpBody = data

                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                holder.completion?(.failure(APIClientError.invalidParameters))
            }
        }

        let task = URLSession.shared.dataTask(with: request, completionHandler: dataTaskCompletionHandler(completion: holder.completion))
        task.resume()
    }

    private func dataTaskCompletionHandler(completion: ASRResultCallback<ASRJSONDictionary>? = nil) -> (Data?, URLResponse?, Error?) -> Void {
        return { data, response, error in
            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let data = data, !data.isEmpty else {
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
    }
}
