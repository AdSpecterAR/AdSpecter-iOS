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
    func adLoaderDidUpdate(_ loader: ASRAdLoader)
}

public class ASRAdLoader: NSObject {
    var advertisement: ASRAdvertisement? {
        didSet {
            guard advertisement != oldValue else {
                return
            }
            if let oldValue = oldValue {
                NotificationCenter.default.removeObserver(self, name: ASRAdvertisement.objectDidUpdateNotificationName(forObjectID: oldValue.objectID), object: nil)
            }
            guard let ad = advertisement else {
                return
            }

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(advertisementDidUpdate),
                name: ASRAdvertisement.objectDidUpdateNotificationName(forObjectID: ad.objectID),
                object: nil
            )

            if let _ = ad.image {
                delegate?.adLoaderDidUpdate(self)
            }
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
        advertisement?.impression?.reportTap()
    }

    @objc
    public func advertisementDidUpdate(notification: Notification) {
        delegate?.adLoaderDidUpdate(self)
    }
}
