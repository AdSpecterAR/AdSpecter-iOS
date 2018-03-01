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

    private let aspectRatio: CGFloat = 4.0 / 3.0

    private let plane: SCNPlane = {
        let node = SCNPlane()
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

    public var maxSizeDimensions: CGSize {
        didSet {
            let width = maxSizeDimensions.width
            let height = maxSizeDimensions.height
            guard maxSizeDimensions.height > 0 else {
                plane.width = width
                plane.height = (3 * width) / 4
                return
            }

            let aspectRatio = width / height
            if aspectRatio >= self.aspectRatio {
                // Too wide
                plane.width = (4 * height) / 3
                plane.height = height
            } else {
                // Too tall
                plane.width = width
                plane.height = (3 * width) / 4
            }
        }
    }

    public override init() {
        maxSizeDimensions = .zero
        super.init()
        AdSpecter.shared.adManager.populate(node: self)
    }

    public convenience init(maxSizeDimensions: CGSize) {
        self.init()
        self.maxSizeDimensions = maxSizeDimensions
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
