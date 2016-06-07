//
//  BonNetwork.swift
//  Bon
//
//  Created by Chris on 16/4/18.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class BonNetwork: NSObject {
    
    var alamoFireManager = Alamofire.Manager.sharedInstance
    
    /**
     *   login function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func post(parameters: [String : AnyObject]?, success: (value: String) -> Void) {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, BIT.URL.AuthActionURL, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print(error)
                }
        }
        
        
    }

    
    static func post(parameters: [String : AnyObject]?, success: (value: String) -> Void, fail: (error : Any) -> Void) {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, BIT.URL.AuthActionURL, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    fail(error: error)
                }
        }
        
        
    }
    
    static func get(URL: String, success: (value: String) -> Void) {
        
        Alamofire.request(.GET, URL)
            .responseString{ response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print(error)
                }
        }
        
    }
    
    /**
     *   getLoginState function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func getLoginState(success :(value : String) -> Void) {
        
        Alamofire.request(.POST, BIT.URL.RadUserInfoURL)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
    }
    
    
}