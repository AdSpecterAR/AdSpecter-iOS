//
//  AdManager.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import UIKit

public class AdManager: NSObject {
    var appSession: ASRAppSession
    // TODO: Move this back to DeveloperManager
    var sessionID: String?

    // TODO: Cache this on the appropriate thread object
    let dateFormatter = DateFormatter()

    var imageFetchQueue = DispatchQueue(label: "com.adspecter.AdSpecter-iOS.imageQueue", qos: .userInteractive)

    private var pendingLoaders: [WeakObject<ASRAdLoader>] = []
    var adQueue: [ASRAdvertisement] = []
    
    override init() {
        appSession = ASRAppSession()
        super.init()
    }

    func setDeveloperKey(_ key: String) {
        APIClient.shared.developerKey = key
        fetchNextAdImageURL()
    }

    func populatePendingLoaders() {
        var loadersProcessed: Int = 0
        for loader in pendingLoaders {
            guard let realLoader = loader.object, let nextAd = adQueue.first else {
                return
            }
            realLoader.advertisement = nextAd
            if adQueue.count > 1 {
                adQueue = Array(adQueue.dropFirst())
            }

            // TODO: Probably want better logic around this
            nextAd.createImpression { result in
                switch result {
                case .failure(_):
                    break

                case let .success(impression):
                    nextAd.impression = impression
                    impression.markShown()
                }
            }
            loadersProcessed += 1
        }

        pendingLoaders = Array(pendingLoaders.dropFirst(loadersProcessed))
    }

    func populate(loader: ASRAdLoader) {
        pendingLoaders.append(WeakObject(loader))
        populatePendingLoaders()
    }
}
