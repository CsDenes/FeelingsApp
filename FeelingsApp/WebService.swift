//
//  PostImage.swift
//  FeelingsApp
//
//  Created by Denes Csizmadia on 2017. 03. 11..
//  Copyright © 2017. Denes Csizmadia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class WebService {
    
    
    class func PostImage(image: UIImage){
        let postURI = "http://127.0.0.1:8000/images/" //"https://csd1994.pythonanywhere.com/api/FeelREST/"
//        let startIndex = image.index(image.startIndex, offsetBy: 0)
//        let endIndex = image.index(image.startIndex, offsetBy: 200)
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        let parameters: Parameters = [
            "name": strBase64
        ]
        Alamofire.request(postURI, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as! String)   // result of response serialization
            
            
            func convertToDictionary(text: String) -> [String: Any]? {
                if let data = text.data(using: .utf8) {
                    do {
                        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                return nil
            }

            
                let str = response.result.value as! String
                let dict = convertToDictionary(text: str)
                print((dict?["ha"] as! Double))
            
                     }
        
    }
    
    
   


}
