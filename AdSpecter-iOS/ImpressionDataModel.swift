//
//  ImpressionDataModel.swift
//  AdSpecter-iOS
//
//  Created by John Li on 1/31/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation


class ImpressionDataModel {
    var impressionId: Int?
    
    var hasAdBeenShown: Bool
    var hasAdBeenServed: Bool
    var hasAdBeenClicked: Bool
    
    var developerAppID: String
    var campaignID: String
    
    var timeAdWasServed: String
    var timeAdWasShown: String?
    var timeAdWasClicked: String?
    
    let dateFormatter = ISO8601DateFormatter()
    
    init() {
        hasAdBeenShown = false
        hasAdBeenServed = false
        hasAdBeenClicked = false
        
        developerAppID = "1"        // change
        campaignID = "1"            // change
        
        timeAdWasServed = dateFormatter.string(from: Date())
    }
}
