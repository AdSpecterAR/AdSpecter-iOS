//
//  AdManager.swift
//  AdSpecter_iOS_SDK
//
//  Created by John Li on 1/15/18.
//  Copyright © 2018 John Li. All rights reserved.
//

import Foundation
import ARKit
import Alamofire
import SwiftyJSON


class AdManager {
    var gridMaterial : SCNMaterial = SCNMaterial()
    var planeNode : SCNNode
    var plane : SCNPlane
    var impression : ImpressionDataModel
    var appSession : AppSessionDataModel
    
    let dateFormatter = DateFormatter()
    
    init() {
        planeNode = SCNNode()
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        plane = SCNPlane(width: 0.4, height: 0.3)
        impression = ImpressionDataModel()
        appSession = AppSessionDataModel()
        
//        initializeAdNode()
    }
    
    func showAdNode() {
        self.impression.hasAdBeenShown = true
        self.impression.timeAdWasShown = self.dateFormatter.string(from: Date())
        sendImpressionData()
//        return planeNode
    }
    
    
    func constructImpressionPostData() -> [String : Any] {
        var parameters : [String : Any] = [
            "impression": [
                "served_at" : impression.timeAdWasServed,
                "shown_at" : impression.timeAdWasShown,
                "developer_app_id" : impression.developerAppID,
                "campaign_id" : impression.campaignID,
                "app_session_id" : sessionId,
                "served" : impression.hasAdBeenServed,
                "shown" : impression.hasAdBeenShown,
                "clicked" : impression.hasAdBeenClicked
            ]
        ]
        
        return parameters
    }
    
    func createImpression() {
        let parameters : [String : Any] = constructImpressionPostData()
        
        print("***************************")
        print("creating impressions data request")
        
        Alamofire.request(
            "\(adSpecterBaseURL)\("/impressions")",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
            ).responseJSON { response in
                print("***************************")
                print("create impressions data response \(response)")
                
                if let responseData = response.result.value {
                    let json : JSON = JSON(responseData)
                    
                    self.impression.impressionId = json["impression"]["id"].intValue
                } else {
                    // error from creating impression
                }
        }
    }
    
    func sendImpressionData() {
        let parameters : [String : Any] = constructImpressionPostData()
        
        Alamofire.request("\(adSpecterBaseURL)/impressions/\(impression.impressionId!))", method: .post, encoding: JSONEncoding.default).responseJSON {
            response in
            
            print("***************************")
            print("send impressions data response \(response)")
            
            if let responseData = response.result.value {
                let json : JSON = JSON(responseData)
            }
        }
    }
    
    func initializeAdNode() {
        Alamofire.request("\(adSpecterBaseURL)\("/test")", method: .get).responseJSON {
            response in
            
            print("***************************")
            print("get ad asset response \(response)")
            
            if let responseData = response.result.value {
                let json : JSON = JSON(responseData)
                
                let imageURL : String = json["image_url"].stringValue
                
                print("***************************")
                print("imageURL \(imageURL)")
                
                DispatchQueue.main.async {
                    print("***************************")
                    print("async update")
                    
                    // send telemetry to that ad has been served
                    self.impression.hasAdBeenServed = true
                    self.impression.timeAdWasServed = self.dateFormatter.string(from: Date())
                    
                    self.createImpression()
                    
                    self.setupPlane(imageURL: imageURL)
                }
            } else {
                print("***************************")
                print("api call error")
            }
        }
    }
    
    func setImage(imageURL : String) -> UIImage {
        var image : UIImage?
        let url = URL(string: imageURL)
        
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)!
        } else {
            print("no data")
            return image!
        }
    }
    
    func setupPlane(imageURL: String) {
        let image = setImage(imageURL: imageURL)
        
        gridMaterial.diffuse.contents = image
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
    }
}
