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


//let adSpecterBaseURL : String = "http://10.0.0.158:3000" // home wifi
    let adSpecterBaseURL : String = "http://192.168.0.114:3000"

public class AdSpecter {
    static let adManager: AdManager = AdManager()
    
    // authenticates developer's app
    public class func setDeveloperKey(_ appID: String) {
        let developerManager = DeveloperManager(appID: appID)
        
        developerManager.verifyAppID()
    }
    
    // sends an impression to the server that ad has been served but not shown, make async to setDeveloperKey's return
    public class func initializeAdNode() -> SCNNode {
        adManager.initializeAdNode()
        
        return adManager.planeNode
    }

    
    // this method 1) shows the ad node 2) sends an impression to the server that ad has been shown
    public class func showAdNode(_ planeAnchor: ARPlaneAnchor,_ ASPlaneNode: SCNNode,_ node: SCNNode) {
        // need changing to more absolute position
        ASPlaneNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        
        node.addChildNode(ASPlaneNode)
        
        adManager.showAdNode()
    }
}


