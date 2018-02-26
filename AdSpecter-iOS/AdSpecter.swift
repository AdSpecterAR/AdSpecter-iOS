//
//  AdSpecter.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation
import SceneKit

public class AdSpecter {
    private var developerToken: String?
    let adManager: AdManager = AdManager()

    public static let shared: AdSpecter = AdSpecter()
    
    private init() { }

    public func setDeveloperKey(_ appID: String) {
        let developerManager = DeveloperManager(appID: appID)
        developerManager.verifyAppID() { result in
            switch result {
            case .failure:
                break

            case let .success(sessionID):
                self.adManager.sessionID = sessionID
            }
        }
        adManager.setDeveloperToken(appID)
    }
}
