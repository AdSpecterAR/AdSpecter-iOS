//
//  AdManager+Networking.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/13/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation

extension AdManager {
    func createImpression(completion: ASRErrorCallback? = nil) {
        var parameters = impression.toJSON()
        if let sessionID = sessionID {
            parameters["app_session_id"] = sessionID
        }

        APIClient.shared.makeRequest(
            to: "impressions",
            method: .post,
            parameters: parameters
        ) { result in
            switch result {
            case let .failure(error):
                completion?(error)

            case let .success(json):
                var copiedJSON = json
                // TODO: Date should be provided by server. Handshake if necessary.
                copiedJSON["served_at"] = self.dateFormatter.string(from: Date())
                let impression = ASRImpression(json: copiedJSON)
                impression?.hasAdBeenServed = true
                if let impression = impression {
                    self.impression = impression
                }
                completion?(nil)
            }
        }
    }

    func sendImpressionData(completion: ASRErrorCallback? = nil) {
        guard let impressionId = impression.impressionID else {
            completion?(APIClientError.invalidImpressionID)
            return
        }

        APIClient.shared.makeRequest(
            to: "impressions/" + String(impressionId),
            method: .post
        ) { result in
            switch result {
            case let .failure(error):
                completion?(error)

            case .success:
                completion?(nil)
            }
        }
    }

    func fetchNextAdImageURL(completion: ASRErrorCallback? = nil) {
        // TODO: Change this path
        APIClient.shared.makeRequest(
            to: "ad_units/default",
            method: .get
        ) { result in
            switch result {
            case let .failure(error):
                completion?(error)

            case let .success(json):
                guard let adJSON = json["ad_unit"] as? ASRJSONDictionary else {
                    completion?(APIClientError.invalidJSON)
                    return
                }

                let ad = ASRAdvertisement(json: adJSON)

                guard let imageURL = ad?.imageURL else {
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
