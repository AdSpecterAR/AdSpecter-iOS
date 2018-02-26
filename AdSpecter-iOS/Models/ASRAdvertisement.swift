//
//  Advertisement.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/25/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation

class ASRAdvertisement: JSONDecodable {
    var advertisementID: String
    
    var isActive: Bool = false
    var title: String?
    var description: String?

    var destinationURL: URL?
    var imageURL: URL?

    required init?(json: ASRJSONDictionary) {
        guard let advertisementID = json["id"] as? Int else {
            return nil
        }

        self.advertisementID = String(advertisementID)

        guard let isActive = json["active"] as? Bool, isActive else {
            return nil
        }
        self.isActive = isActive

        title = json["title"] as? String
        description = json["description"] as? String

        if let rawDestinationURL = json["click_url"] as? String {
            destinationURL = URL(string: rawDestinationURL)
        }

        if let rawImageURL = json["ad_unit_url"] as? String {
            imageURL = URL(string: rawImageURL)
        }
    }
}
