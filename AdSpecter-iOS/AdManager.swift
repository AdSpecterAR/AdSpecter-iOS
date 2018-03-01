//
//  AdManager.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation

class AdManager {
    var appSession: ASRAppSession
    // TODO: Move this back to DeveloperManager
    var sessionID: String?
    var impression: ASRImpression?

    // TODO: Cache this on the appropriate thread object
    let dateFormatter = DateFormatter()

    // TODO: Set this in rest client to include in all request headers
    private var developerToken: String?

    var imageFetchQueue = DispatchQueue(label: "com.adspecter.AdSpecter-iOS.imageQueue", qos: .userInteractive)

    private var pendingNodes: [WeakObject<ASRAdNode>] = []
    var adQueue: [(ad: ASRAdvertisement, image: UIImage)] = []
    
    init() {
        appSession = ASRAppSession()
    }

    func setDeveloperToken(_ token: String) {
        developerToken = token
        fetchNextAdImageURL()
    }

    func populatePendingNodes() {
        var nodesProcessed: Int = 0
        for node in pendingNodes {
            guard let realNode = node.object, let nextAd = adQueue.first else {
                return
            }
            realNode.image = nextAd.image
            if adQueue.count > 1 {
                adQueue = Array(adQueue.dropFirst())
            }

            // TODO: Probably want better logic around this
            createImpression(for: nextAd.ad)
            nodesProcessed += 1
        }

        pendingNodes = Array(pendingNodes.dropFirst(nodesProcessed))
        // TODO: Handle impression API calls
    }

    func populate(node: ASRAdNode) {
        pendingNodes.append(WeakObject(node))
        populatePendingNodes()
    }
}
