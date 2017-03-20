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
    
    
    class func PostImage(image: String){
        let postURI = "https://csd1994.pythonanywhere.com/api/FeelREST/"
        let startIndex = image.index(image.startIndex, offsetBy: 0)
        let endIndex = image.index(image.startIndex, offsetBy: 200)
        let parameters: Parameters = [
            "name": image[startIndex...endIndex]
        ]
        Alamofire.request(postURI, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .responseJSON { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
        }
        
    }



}
