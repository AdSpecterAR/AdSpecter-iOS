//
//  AdSpecter.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


let adSpecterBaseURL : String = "http://10.0.0.158:3000" // home wifi
//    let adSpecterBaseURL : String = "http://192.168.0.57:3000"

public class AdSpecter {
    static let adManager: AdManager = AdManager()
    
    public class func setDeveloperKey(_ appID: String) {
        let developerManager = DeveloperManager(appID: appID)
        
        developerManager.verifyAppID()
    }
    
    public class func initializeAdNode() -> SCNNode {
        adManager.initializeAdNode()
        
        return adManager.planeNode
    }

    public class func showAdNode(_ planeAnchor: ARPlaneAnchor,_ ASPlaneNode: SCNNode,_ node: SCNNode) {
        ASPlaneNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        node.addChildNode(ASPlaneNode)
        
        adManager.showAdNode()
    }
}


