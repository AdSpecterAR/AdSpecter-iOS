//
//  AdManager+Networking.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/13/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import UIKit

extension ASRImpression {
    func markShown(completion: ASRErrorCallback? = nil) {
        APIClient.shared.makeRequest(
            to: "impressions/\(objectID)/shown",
            method: .put,
            parameters: nil
        ) { result in
            switch result {
            case let .failure(error):
                completion?(error)

            case .success:
                completion?(nil)
            }
        }
    }

    func reportTap(completion: ASRErrorCallback? = nil) {
        APIClient.shared.makeRequest(
            to: "impressions/\(objectID)/clicked",
            method: .put,
            parameters: nil
        ) { result in
            switch result {
            case let .failure(error):
                completion?(error)

            case .success:
                completion?(nil)
            }
        }
    }
}

extension ASRAdvertisement {
    func createImpression(completion: ASRResultCallback<ASRImpression>? = nil) {
        // TODO: Update parameters
        var parameters: ASRJSONDictionary = [:]
        parameters["ad_unit_id"] = objectID

        APIClient.shared.makeRequest(
            to: "impressions",
            method: .put,
            parameters: parameters
        ) { result in
            switch result {
            case let .failure(error):
                completion?(.failure(error))

            case let .success(json):
                var copiedJSON = json
                // TODO: Date should be provided by server. Handshake if necessary.
                copiedJSON["served_at"] = Thread.current.iso8601Formatter.string(from: Date())
                guard let impression = ASRImpression(json: copiedJSON) else {
                    completion?(.failure(APIClientError.invalidJSON))
                    return
                }
                impression.hasAdBeenServed = true
                completion?(.success(impression))
            }
        }
    }
}

extension AdManager {
    func fetchNextAdImageURL(completion: ASRErrorCallback? = nil) {
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
                guard let ad = ASRAdvertisement(json: adJSON) else {
                    completion?(APIClientError.invalidJSON)
                    return
                }

                guard let imageURL = ad.imageURL else {
                    completion?(APIClientError.invalidJSON)
                    return
                }

                self.fetchImage(for: imageURL) { [weak self] image in
                    guard let image = image else {
                        completion?(APIClientError.invalidJSON)
                        return
                    }

                    ad.image = image
                    self?.adQueue.append(ad)
                    self?.populatePendingLoaders()
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
