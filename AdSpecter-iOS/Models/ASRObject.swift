//
//  ASRObject.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 4/10/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class ASRObject: NSObject {
    let objectID: String

    required init?(json: ASRJSONDictionary) {
        guard let objectID = json["id"] as? String else {
            return nil
        }
        self.objectID = objectID
        super.init()
    }
}

extension ASRObject: JSONDecodable { }

extension ASRObject {
    static func objectDidUpdateNotificationName(forObjectID objectID: String? = nil) -> Notification.Name {
        guard let objectID = objectID else {
            return Notification.Name("\(type(of: self)).objectDidUpdateNotification")
        }
        return Notification.Name("\(type(of: self)).objectDidUpdateNotification.\(objectID)")
    }

    func notifyObjectUpdated() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: type(of: self).objectDidUpdateNotificationName(),
                object: nil
            )

            NotificationCenter.default.post(
                name: type(of: self).objectDidUpdateNotificationName(forObjectID: self.objectID),
                object: nil
            )
        }
    }
}
