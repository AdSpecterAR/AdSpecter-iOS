//
//  Advertisement.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/25/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation

class ASRAdvertisement: JSONCodable {
    var advertisementID: String
    
    var isActive: Bool = false
    var createdAt: Date?
    var updatedAt: Date?
    var title: String?
    var description: String?

    var destinationURL: URL?
    var imageURL: URL?

    required init?(json: ASRJSONDictionary) {
        guard let advertisementID = json["id"] as? Int else {
            return nil
        }

        self.advertisementID = String(advertisementID)
        isActive = json["active"] as? Bool ?? false
        // TODO: Handle dates

        if let rawCreatedAt = json["created_at"] as? String {
            createdAt = Thread.current.iso8601Formatter.date(from: rawCreatedAt)
        }

        if let rawUpdatedAt = json["updated_at"] as? String {
            updatedAt = Thread.current.iso8601Formatter.date(from: rawUpdatedAt)
        }

        title = json["title"] as? String
        description = json["description"] as? String

        if let rawDestinationURL = json["click_url"] as? String {
            destinationURL = URL(string: rawDestinationURL)
        }

        if let rawImageURL = json["ad_unit_url"] as? String {
            imageURL = URL(string: rawImageURL)
        }
    }

    func toJSON() -> ASRJSONDictionary {
        var json = ASRJSONDictionary()
        json["id"] = advertisementID
        json["active"] = isActive

        if let createdAt = createdAt {
            json["created_at"] = Thread.current.iso8601Formatter.string(from: createdAt)
        }

        if let updatedAt = updatedAt {
            json["updated_at"] = Thread.current.iso8601Formatter.string(from: updatedAt)
        }

        json["title"] = title
        json["description"] = description
        json["click_url"] = destinationURL?.absoluteString
        json["ad_unit_url"] = imageURL?.absoluteString
        return json
    }
}
