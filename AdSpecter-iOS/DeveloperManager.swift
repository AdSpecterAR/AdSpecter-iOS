//
//  DeveloperManager.swift
//  AdSpecter-iOS
//
//  Created by John Li on 2/3/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation

class DeveloperManager {
    enum Result {
        case success(String)
        case failure(Error)
    }

    let developerAppID : String
    let device : DeviceDataModel
    
    init(appID : String) {
        developerAppID = appID
        device = DeviceDataModel()
    }
    
    func verifyAppID(completion: ((Result) -> Void)? = nil) {
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

        let path: String = APIClient.baseURL + "developer_app/authenticate"

        APIClient.shared.makeRequest(
            to: path,
            method: .post,
            parameters: parameters
        ) { result in
            switch result {
            case let .failure(error):
                completion?(.failure(error))

            case let .success(json):
                guard let updatedSessionID = (json["app_session"] as? ASRJSONDictionary)?["id"] as? Int else {
                    completion?(.failure(APIClientError.invalidJSON))
                    return
                }

                completion?(.success(String(updatedSessionID)))
            }
        }
    }
}
