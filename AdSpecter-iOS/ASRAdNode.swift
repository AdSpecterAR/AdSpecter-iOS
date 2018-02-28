//
//  ASRAdNode.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/12/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import UIKit
import SceneKit

public protocol ASRAdNodeDelegate: class {
    func adNode(_ node: ASRAdNode, wasTappedIn sceneView: SCNView)
}

public class ASRAdNode: SCNNode {
    private class WrappedDelegate: NSObject {
        weak var delegate: ASRAdNodeDelegate?
        weak var view: SCNView?

        init(delegate: ASRAdNodeDelegate, view: SCNView) {
            self.delegate = delegate
            self.view = view
        }
    }

    private let plane: SCNPlane = {
        let node = SCNPlane(width: 0.4, height: 0.3)
        return node
    }()
    
    private let gridMaterial: SCNMaterial = {
        let material = SCNMaterial()
        return material
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(sceneWasTapped))
    }()

    private var wrappedDelegate: WrappedDelegate?

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

    public func setDelegate(_ delegate: ASRAdNodeDelegate?, in view: SCNView) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.setDelegate(delegate, in: view)
            }
            return
        }
        guard let delegate = delegate else {
            self.wrappedDelegate = nil
            return
        }
        self.wrappedDelegate = WrappedDelegate(delegate: delegate, view: view)
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc
    private func sceneWasTapped(sender: UITapGestureRecognizer) {
        guard sender == tapRecognizer else {
            return
        }
        guard let delegate = wrappedDelegate?.delegate, let view = wrappedDelegate?.view else {
            return
        }

        let tapLocation = sender.location(in: view)
        let hits = view.hitTest(tapLocation, options: [.ignoreHiddenNodes: NSNumber(value: true)])
        let wasTapped = hits.contains(where: { $0.node == self })
        guard wasTapped else {
            return
        }

        // TODO: Make API request to track click
        delegate.adNode(self, wasTappedIn: view)
    }
}
