//
//  Advertisement.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/25/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation
import UIKit

class ASRAdvertisement: ASRObject {
    let isActive: Bool
    let title: String?
    let adDescription: String?

    let destinationURL: URL?
    let imageURL: URL?

    var image: UIImage? {
        didSet {
            guard image != oldValue else {
                return
            }
            notifyObjectUpdated()
        }
    }

    var impression: ASRImpression? {
        didSet {
            guard impression != oldValue else {
                return
            }
            notifyObjectUpdated()
        }
    }

    required init?(json: ASRJSONDictionary) {
        guard let advertisementID = json["id"] as? Int else {
            return nil
        }

        guard let isActive = json["active"] as? Bool else {
            return nil
        }
        self.isActive = isActive

        title = json["title"] as? String
        adDescription = json["description"] as? String

        if let rawDestinationURL = json["click_url"] as? String {
            destinationURL = URL(string: rawDestinationURL)
        } else {
            destinationURL = nil
        }

        if let rawImageURL = json["ad_unit_url"] as? String {
            imageURL = URL(string: rawImageURL)
        } else {
            imageURL = nil
        }
        var json = json
        json["id"] = "\(advertisementID)"
        super.init(json: json)
    }
}
