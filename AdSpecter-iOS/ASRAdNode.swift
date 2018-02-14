//
//  ASRAdNode.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/12/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import UIKit
import ARKit

public class ASRAdNode: SCNNode {
    private let plane: SCNPlane = {
        let node = SCNPlane(width: 0.4, height: 0.3)
        return node
    }()
    
    private let gridMaterial: SCNMaterial = {
        let material = SCNMaterial()
        return material
    }()

    var image: UIImage? {
        didSet {
            gridMaterial.diffuse.contents = image
            plane.materials = [gridMaterial]
            geometry = plane
        }
    }
    
    public override init() {
        super.init()
        AdSpecter.shared.adManager.populate(node: self)
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
