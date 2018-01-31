//
//  ImpressionDataModel.swift
//  AdSpecter-iOS
//
//  Created by John Li on 1/31/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation


class ImpressionDataModel {
    var hasAdBeenShown : Bool
    var hasAdBeenServed : Bool
    var hasAdBeenShownFor30Seconds : Bool
    var hasAdBeenClicked : Bool
    var sessionId : String
    
    init(currentSessionID : String) {
        hasAdBeenShown = false
        hasAdBeenServed = false
        hasAdBeenShownFor30Seconds = false
        hasAdBeenClicked = false
        sessionId = currentSessionID
    }
}
