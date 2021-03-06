//
//  ImpressionDataModel.swift
//  AdSpecter-iOS
//
//  Created by John Li on 1/31/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class ASRImpression: ASRObject, JSONEncodable {
    let developerAppID: String
    let campaignID: String
    
    var hasAdBeenShown: Bool
    var hasAdBeenServed: Bool
    var hasAdBeenClicked: Bool
    
    var servedAt: Date
    var shownAt: Date?
    var clickedAt: Date?
    
    required init?(json: ASRJSONDictionary) {
        guard let rawImpressionID = (json["impression"] as? ASRJSONDictionary)?["id"] as? Int else {
            return nil
        }

        guard let rawServedAt = json["served_at"] as? String, let servedAt = Thread.current.iso8601Formatter.date(from: rawServedAt) else {
            return nil
        }
        self.servedAt = servedAt

        hasAdBeenServed = json["served"] as? Bool ?? false
        hasAdBeenShown = json["shown"] as? Bool ?? false
        hasAdBeenClicked = json["clicked"] as? Bool ?? false

        // TODO: Change this
        developerAppID = json["developer_key"] as? String ?? "1"
        campaignID = json["campaign_id"] as? String ?? "1"

        var jsonCopy = json
        jsonCopy["id"] = "\(rawImpressionID)"
        super.init(json: jsonCopy)

        if let rawShownAt = json["shown_at"] as? String {
            shownAt = Thread.current.iso8601Formatter.date(from: rawShownAt)
        }

        if let rawClickedAt = json["clicked_at"] as? String {
            clickedAt = Thread.current.iso8601Formatter.date(from: rawClickedAt)
        }
    }
    
    func toJSON() -> ASRJSONDictionary {
        var json: ASRJSONDictionary = [:]
        json["impression"] = ["id": Int(objectID)]
        json["shown"] = hasAdBeenShown
        json["served"] = hasAdBeenServed
        json["clicked"] = hasAdBeenClicked
        json["developer_key"] = developerAppID
        json["campaign_id"] = campaignID

        json["served_at"] = Thread.current.iso8601Formatter.string(from: servedAt)

        if let shownAt = shownAt {
            json["shown_at"] = Thread.current.iso8601Formatter.string(from: shownAt)
        }

        // TODO: Make sure we want to send this key
        if let clickedAt = clickedAt {
            json["clicked_at"] = Thread.current.iso8601Formatter.string(from: clickedAt)
        }

        return json
    }
}
