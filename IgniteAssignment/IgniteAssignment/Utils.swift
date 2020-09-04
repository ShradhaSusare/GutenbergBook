//
//  Utils.swift
//  IgniteAssignment
//
//  Created by Shraddha on 9/3/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import Foundation
import UIKit
class Utils  {

    //MARK: API CALL
       
    func dataTaskWith(url : String,param : [String : String], completion: @escaping (_ success: Bool, _ object: [String:Any]?, _ err: Error?) -> Void) {
        
        //let url1 = "http://skunkworks.ignitesol.com:8000/books?mime_type=image"

        var datatask : URLSessionDataTask?
        let url = url
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: url)
        for (key,value) in param {
        items.append(URLQueryItem(name: key, value: value))
        }
        items.append(URLQueryItem(name: "mime_type", value: "image"))
        myURL?.queryItems = items
        let request =  URLRequest(url: (myURL?.url)!)
        
        datatask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            // Check the response
            self.parseResponse(data: data, response: response, error: error, completion: { response in
                if response != nil {
                    completion(true, response,nil)
                } else {
                    completion(false, nil, error)
                }
            }
            )
        })
        datatask!.resume()
    }
    
    func parseResponse(data: Data?, response: URLResponse?,error: Error?, completion: @escaping (_ response: [String: Any]?) -> Void)  {
        if (error == nil)  {
            if let data = data {
            do {
                let responseObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any];
                completion(responseObj)
            }catch let err {
                print("ERror\(err)")
            }
            } else {
                completion(nil)
            }
        }
    }
}
