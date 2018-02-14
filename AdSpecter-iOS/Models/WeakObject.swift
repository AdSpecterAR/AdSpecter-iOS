//
//  WeakObject.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/13/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class WeakObject<T: AnyObject>: NSObject {
    weak var object: T?

    init(_ object: T) {
        self.object = object
        super.init()
    }
}
