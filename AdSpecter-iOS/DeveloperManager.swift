//
//  DeveloperManager.swift
//  AdSpecter-iOS
//
//  Created by John Li on 2/3/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var sessionId : Int?

class DeveloperManager {
    let developerAppID : String
    let device : DeviceDataModel
    
    init(appID : String) {
        developerAppID = appID
        device = DeviceDataModel()
    }
    
    func verifyAppID() {
        let parameters : [String : Any] = [
            "client_api_key": developerAppID,
            "device" : [
                "device_model": device.model,
                "localized_model": device.localizedModel,
                "device_model_name": device.modelName,
                "name": device.name,
                "system_name": device.systemName,
                "system_version": device.systemVersion
            ]
        ]
        
        Alamofire.request(
            "\(adSpecterBaseURL)\("/developer_app/authenticate")",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
            ).responseJSON { response in
                print("***************************")
                print("verifying client App ID \(response)")
                
                if let responseData = response.result.value {
                    let json : JSON = JSON(responseData)
                    
                    print("***************************")
                    print("json!!! \(json["app_session"]["id"])")
                    
                    
                    sessionId = json["app_session"]["id"].intValue
                    
                    // callback here
//                    
//                    let adManager = AdManager()
//                    
//                    adManager.initializeAdNode()
                    
                    print("***************************")
                    print("sessionId!!! \(sessionId)")
                }
        }
    }
}
