//
//  ASRAdNode.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/12/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import UIKit
import SceneKit

public class ASRAdNode: SCNNode {
    private lazy var adLoader: ASRAdLoader = {
        let loader = ASRAdLoader(delegate: self)
        return loader
    }()

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

    public weak var superview: SCNView? {
        didSet {
            guard let superview = superview, superview != oldValue else {
                return
            }
            DispatchQueue.main.async {
                superview.addGestureRecognizer(self.tapRecognizer)
            }
        }
    }

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
        _ = adLoader
    }

    public convenience init(maxSizeDimensions: CGSize) {
        self.init()
        self.maxSizeDimensions = maxSizeDimensions
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func sceneWasTapped(sender: UITapGestureRecognizer) {
        guard sender == tapRecognizer else {
            return
        }

        guard let superview = superview else {
            return
        }

        let tapLocation = sender.location(in: superview)
        let hits = superview.hitTest(tapLocation, options: [.ignoreHiddenNodes: NSNumber(value: true)])
        let wasTapped = hits.contains(where: { $0.node == self })
        guard wasTapped else {
            return
        }

        // TODO: Make API request to track click
        print("AD WAS TAPPED")
        adLoader.reportTap()
    }
}

extension ASRAdNode: ASRAdLoaderDelegate {
    public func adLoader(_ loader: ASRAdLoader, didLoad image: UIImage) {
        self.image = image
    }
}
