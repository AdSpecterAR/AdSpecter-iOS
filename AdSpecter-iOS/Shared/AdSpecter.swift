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

    @objc
    public let adManager: AdManager = AdManager()

    @objc
    public static let shared: AdSpecter = AdSpecter()
    
    private override init() { }

    @objc
    public func setDeveloperKey(_ key: String) {
        adManager.setDeveloperKey(key)
        let developerManager = DeveloperManager(developerKey: key)
        developerManager.verifyAppID() { result in
            switch result {
            case .failure:
                break

            case let .success(sessionID):
                self.adManager.sessionID = sessionID
                APIClient.shared.appSessionID = sessionID
            }
        }
    }
}
