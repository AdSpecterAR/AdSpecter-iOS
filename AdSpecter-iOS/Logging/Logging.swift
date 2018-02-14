//
//  Logging.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/12/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

// TODO: Add better logging that will happen off main thread

func ASRLog(_ log: String) {
    #if DEBUG
    print(log)
    #else
    #endif
}
