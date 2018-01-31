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


public class AdSpecter {
    
    public class func initializeAdNode() -> SCNNode {
        let adManager = AdManager()
        
        return adManager.planeNode
    }

}


