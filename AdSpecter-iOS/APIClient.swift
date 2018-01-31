//
//  APIClient.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    
    let adSpecterBaseURL : String = "http://10.0.0.158:3000"
    
    var adImageURL : String = ""
    
    func get(url: String) {
        Alamofire.request("\(adSpecterBaseURL)\(url)", method: .get).responseJSON {
            response in

            return response
        }
    }
}


