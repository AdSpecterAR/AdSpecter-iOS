//
//  ImpressionDataModel.swift
//  AdSpecter-iOS
//
//  Created by John Li on 1/31/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class ASRImpression: JSONCodable {
    var impressionID: String?
    
    var hasAdBeenShown: Bool
    var hasAdBeenServed: Bool
    var hasAdBeenClicked: Bool
    
    var developerAppID: String
    var campaignID: String
    
    var servedAt: Date
    var shownAt: Date?
    var clickedAt: Date?
    
    init() {
        hasAdBeenShown = false
        hasAdBeenServed = false
        hasAdBeenClicked = false
        
        developerAppID = "1"        // change
        campaignID = "1"            // change
        
        servedAt = Date()
    }
    
    required init?(json: ASRJSONDictionary) {
        guard let rawServedAt = json["served_at"] as? String, let servedAt = Thread.current.iso8601Formatter.date(from: rawServedAt) else {
            return nil
        }

        self.servedAt = servedAt
        // TODO: Implement impression ID
        if let rawImpression = (json["impression"] as? ASRJSONDictionary)?["id"] as? Int {
            impressionID = String(rawImpression)
        }

        hasAdBeenServed = json["served"] as? Bool ?? false
        hasAdBeenShown = json["shown"] as? Bool ?? false
        hasAdBeenClicked = json["clicked"] as? Bool ?? false
        
        // TODO: Change this
        developerAppID = json["developer_app_id"] as? String ?? "1"
        campaignID = json["campaign_id"] as? String ?? "1"

        if let rawShownAt = json["shown_at"] as? String {
            shownAt = Thread.current.iso8601Formatter.date(from: rawShownAt)
        }

        if let rawClickedAt = json["clicked_at"] as? String {
            clickedAt = Thread.current.iso8601Formatter.date(from: rawClickedAt)
        }
    }
    
    func toJSON() -> ASRJSONDictionary {
        var json: ASRJSONDictionary = [:]
        
        if let impressionID = impressionID {
            json["impression"] = ["id": impressionID]
        }
        json["shown"] = hasAdBeenShown
        json["served"] = hasAdBeenServed
        json["clicked"] = hasAdBeenClicked
        json["developer_app_id"] = developerAppID
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
