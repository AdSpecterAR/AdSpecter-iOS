//
//  AdManager.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation
import ARKit

class AdManager {
    var impression : ImpressionDataModel
    var appSession : AppSessionDataModel

    // TODO: Cache this on the appropriate thread object
    let dateFormatter = DateFormatter()

    // TODO: Set this in rest client to include in all request headers
    private var developerToken: String?

    var imageFetchQueue = DispatchQueue(label: "com.adspecter.AdSpecter-iOS.imageQueue", qos: .userInteractive)

    private var pendingNodes: [WeakObject<ASRAdNode>] = []
    var imageQueue: [UIImage] = []
    
    init() {
        impression = ImpressionDataModel()
        appSession = AppSessionDataModel()
    }

    func setDeveloperToken(_ token: String) {
        developerToken = token
        fetchNextAdImageURL()
    }

    func populatePendingNodes() {
        var nodesProcessed: Int = 0
        for node in pendingNodes {
            guard let realNode = node.object, !imageQueue.isEmpty else {
                return
            }
            realNode.image = imageQueue.first
            imageQueue = Array(imageQueue.dropFirst())
            // TODO: Probably want better logic around this
            createImpression()
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
