//
//  ImpressionDataModel.swift
//  AdSpecter-iOS
//
//  Created by John Li on 1/31/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class ImpressionDataModel: JSONCodable {
    var impressionID: Int?
    
    var hasAdBeenShown: Bool
    var hasAdBeenServed: Bool
    var hasAdBeenClicked: Bool
    
    var developerAppID: String
    var campaignID: String
    
    var timeAdWasServed: String
    var timeAdWasShown: String?
    var timeAdWasClicked: String?
    
    init() {
        hasAdBeenShown = false
        hasAdBeenServed = false
        hasAdBeenClicked = false
        
        developerAppID = "1"        // change
        campaignID = "1"            // change
        
        timeAdWasServed = ISO8601DateFormatter().string(from: Date())
    }
    
    required init?(json: ASRJSONDictionary) {
        guard let timeAdWasServed = json["served_at"] as? String else {
            return nil
        }
        
        // TODO: Implement impression ID
        impressionID = (json["impression"] as? ASRJSONDictionary)?["id"] as? Int
        self.timeAdWasServed = timeAdWasServed
        hasAdBeenServed = json["served"] as? Bool ?? false
        hasAdBeenShown = json["shown"] as? Bool ?? false
        hasAdBeenClicked = json["clicked"] as? Bool ?? false
        
        // TODO: Change this
        developerAppID = json["developer_app_id"] as? String ?? "1"
        campaignID = json["campaign_id"] as? String ?? "1"
        
        timeAdWasShown = json["shown_at"] as? String
        timeAdWasClicked = json["clicked_at"] as? String
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
        json["served_at"] = timeAdWasServed
        json["shown_at"] = timeAdWasShown
        // TODO: Make sure we want to send this key
        json["clicked_at"] = timeAdWasClicked
        return json
    }
}
