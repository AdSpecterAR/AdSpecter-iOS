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
    let adSpecterBaseURL : String = "http://10.0.0.158:3000"
    
    init() {
        planeNode = SCNNode()
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        plane = SCNPlane(width: 0.4, height: 0.3)
        
        initializeAdNode()
    }
    
    func showAdNode() -> SCNNode {
        return planeNode
    }
    
    func initializeAdNode() {
        Alamofire.request("\(adSpecterBaseURL)\("/test")", method: .get).responseJSON {
            response in
            
            print("***************************")
            print("response \(response)")
            
            if let responseData = response.result.value {
                let json : JSON = JSON(responseData)
                
                let imageURL : String = json["image_url"].stringValue
                
                print("***************************")
                print("imageURL \(imageURL)")
                
                DispatchQueue.main.async {
                    print("***************************")
                    print("async update")
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
    
    func closure(_ responseData: Any) -> String {
        let json : JSON = JSON(responseData)
        
        print("***************************")
        print("json \(json)")
        
        let imageURL : String = json["image_url"].stringValue
        
        print("***************************")
        print("imageURL \(imageURL)")
        
        return imageURL
    }
    
    func setupPlane(imageURL: String) {
        let image = setImage(imageURL: imageURL)
        
        gridMaterial.diffuse.contents = image
        
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
    }
}

