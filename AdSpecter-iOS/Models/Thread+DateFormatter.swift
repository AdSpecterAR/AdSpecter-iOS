//
//  Thread+DateFormatter.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/25/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import UIKit

extension Thread {
    static let identifier: String = UIApplication.shared.uniqueIdentifier(with: "iso8601Formatter")
    
    var iso8601Formatter: ISO8601DateFormatter {
        if let formatter = threadDictionary[type(of: self).identifier] as? ISO8601DateFormatter {
            return formatter
        } else {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            threadDictionary[type(of: self).identifier] = formatter
            return formatter
        }
    }
}

extension UIApplication {
    func uniqueIdentifier(with path: String) -> String {
        let bundle = Bundle(for: AdManager.self)
        guard let identifier = bundle.bundleIdentifier else {
            return "com.adspecter.AdSpecter-iOS"
        }
        return identifier + "." + path
    }
}
