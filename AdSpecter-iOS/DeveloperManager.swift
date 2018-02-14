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

// TODO: Add this to AdSpecter
var sessionID: Int?

class DeveloperManager {
    let developerAppID : String
    let device : DeviceDataModel
    
    init(appID : String) {
        developerAppID = appID
        device = DeviceDataModel()
    }
    
    func verifyAppID(completion: ASRErrorCallback? = nil) {
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

        let url: String = APIClient.baseURL + "/developer_app/authenticate"
        Alamofire.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseJSON { response in
            print("***************************")
            print("verifying client App ID \(response)")

            guard response.error == nil else {
                completion?(response.error)
                return
            }

            guard let responseJSON = response.result.value as? ASRJSONDictionary else {
                completion?(APIClientError.invalidJSON)
                return
            }

            guard let updatedSessionID = (responseJSON["app_session"] as? ASRJSONDictionary)?["id"] as? Int else {
                completion?(APIClientError.invalidJSON)
                return
            }

            sessionID = updatedSessionID
        }
    }
}
