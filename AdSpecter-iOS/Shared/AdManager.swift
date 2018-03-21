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
    var impression: ASRImpression?

    // TODO: Cache this on the appropriate thread object
    let dateFormatter = DateFormatter()

    // TODO: Set this in rest client to include in all request headers
    private var developerToken: String?

    var imageFetchQueue = DispatchQueue(label: "com.adspecter.AdSpecter-iOS.imageQueue", qos: .userInteractive)

    private var pendingLoaders: [WeakObject<ASRAdLoader>] = []
    var adQueue: [(ad: ASRAdvertisement, image: UIImage)] = []
    
    override init() {
        appSession = ASRAppSession()
        super.init()
    }

    func setDeveloperToken(_ token: String) {
        developerToken = token
        fetchNextAdImageURL()
    }

    func populatePendingLoaders() {
        var loadersProcessed: Int = 0
        for loader in pendingLoaders {
            guard let realLoader = loader.object, let nextAd = adQueue.first else {
                return
            }
            realLoader.image = nextAd.image
            if adQueue.count > 1 {
                adQueue = Array(adQueue.dropFirst())
            }

            // TODO: Probably want better logic around this
            createImpression(for: nextAd.ad)
            loadersProcessed += 1
        }

        pendingLoaders = Array(pendingLoaders.dropFirst(loadersProcessed))
        // TODO: Handle impression API calls
    }

    func populate(loader: ASRAdLoader) {
        pendingLoaders.append(WeakObject(loader))
        populatePendingLoaders()
    }
}
