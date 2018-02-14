//
//  JSONCodable.swift
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 2/12/18.
//  Copyright © 2018 AdSpecter. All rights reserved.
//

import Foundation

typealias JSONCodable = JSONEncodable & JSONDecodable

protocol JSONEncodable {
    func toJSON() -> ASRJSONDictionary
}

protocol JSONDecodable {
    init?(json: ASRJSONDictionary)
}
