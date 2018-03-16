//
//  AdSpecter.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation
import SceneKit

public class AdSpecter: NSObject {
    private var developerToken: String?

    @objc
    public let adManager: AdManager = AdManager()

    @objc
    public static let shared: AdSpecter = AdSpecter()
    
    private override init() { }

    @objc
    public func setDeveloperKey(_ appID: String) {
        print("Setting developer ID to: \(appID)")
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
