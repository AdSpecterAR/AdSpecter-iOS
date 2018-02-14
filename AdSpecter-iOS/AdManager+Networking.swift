//
//  AdManager+Networking.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/13/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import Alamofire

extension AdManager {
    func createImpression(completion: ASRErrorCallback? = nil) {
        var parameters = impression.toJSON()
        if let sessionID = sessionID {
            parameters["app_session_id"] = sessionID
        }

        print("***************************")
        print("creating impressions data request")

        Alamofire.request(
            APIClient.baseURL + "/impressions",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseJSON { response in
            print("***************************")
            print("create impressions data response \(response)")
            guard response.error == nil else {
                completion?(response.error)
                return
            }
            guard var responseJSON = response.value as? ASRJSONDictionary else {
                completion?(APIClientError.invalidJSON)
                return
            }

            responseJSON["served_at"] = self.dateFormatter.string(from: Date())
            let impression = ImpressionDataModel(json: responseJSON)
            impression?.hasAdBeenServed = true
            if let updatedImpression = impression {
                self.impression = updatedImpression
            }

            completion?(nil)
        }
    }

    func sendImpressionData(completion: ASRErrorCallback? = nil) {
        guard let impressionId = impression.impressionID else {
            completion?(APIClientError.invalidImpressionID)
            return
        }

        let url: String = APIClient.baseURL + "/impressions/" + String(impressionId)
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default).responseJSON {
            response in

            print("***************************")
            print("send impressions data response \(response)")
            guard response.error == nil else {
                completion?(response.error)
                return
            }

            guard let _ = response.value else {
                completion?(APIClientError.invalidJSON)
                return
            }

            completion?(nil)
        }
    }

    func fetchNextAdImageURL(completion: ASRErrorCallback? = nil) {
        let url: String = APIClient.baseURL + "/test"
        Alamofire.request(url, method: .get).responseJSON {
            response in

            print("***************************")
            print("get ad asset response \(response)")

            guard response.error == nil else {
                completion?(response.error)
                return
            }

            guard let responseJSON = response.value as? ASRJSONDictionary, let imageURLString = responseJSON["image_url"] as? String else {
                completion?(APIClientError.invalidJSON)
                return
            }

            guard let imageURL = URL(string: imageURLString) else {
                completion?(APIClientError.invalidJSON)
                return
            }

            self.fetchImage(for: imageURL) { [weak self] image in
                guard let image = image else {
                    completion?(APIClientError.invalidJSON)
                    return
                }

                self?.imageQueue.append(image)
                self?.populatePendingNodes()
                completion?(nil)
            }
        }
    }

    private func fetchImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        imageFetchQueue.async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
