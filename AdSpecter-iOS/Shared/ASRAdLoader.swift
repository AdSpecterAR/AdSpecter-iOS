//
//  ASRAdLoader.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/12/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import UIKit

@objc
public protocol ASRAdLoaderDelegate: class {
    func adLoader(_ loader: ASRAdLoader, didLoad image: UIImage)
}

public class ASRAdLoader: NSObject {
    var image: UIImage? {
        didSet {
            guard let image = image, image != oldValue else {
                return
            }
            delegate?.adLoader(self, didLoad: image)
        }
    }

    @objc
    public weak var delegate: ASRAdLoaderDelegate?

    @objc
    public init(delegate: ASRAdLoaderDelegate) {
        super.init()
        self.delegate = delegate
        AdSpecter.shared.adManager.populate(loader: self)
    }

    public func reportTap() {
        // TODO: Implement this
    }
}
