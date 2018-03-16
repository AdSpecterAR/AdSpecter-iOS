//
//  ASRAdLoader.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/12/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import UIKit

public class ASRAdLoader: NSObject {
    private let aspectRatio: CGFloat = 4.0 / 3.0
    var image: UIImage?

    @objc
    public var maxSizeDimensions: CGSize

    public override init() {
        maxSizeDimensions = .zero
        super.init()
        AdSpecter.shared.adManager.populate(loader: self)
    }
}
