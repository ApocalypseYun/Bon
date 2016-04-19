//
//  BonService.swift
//  Bon
//
//  Created by Chris on 16/4/18.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation
import Alamofire

class BonNetwork: NSObject {
    
    /**
     *   login function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func login(parameters: [String : AnyObject]?, success: (value: String) -> Void) {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, BIT.URL.DoLoginURL, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
        
    }
    
    
    /**
     *   keepLive function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func keepLive(parameters: [String : AnyObject]?, success: (value: String) -> Void) {
        
        Alamofire.request(.POST, BIT.URL.KeepLiveURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
        
    }
    
    /**
     *   logout function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func logout(parameters: [String : AnyObject]?, success: (value : String) -> Void) {
        
        Alamofire.request(.POST, BIT.URL.DoLogoutURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
    
    // FIXME: It doesn't work well
    
    /**
     *   forceLogout function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func forceLogout(parameters :[String : AnyObject]?, success :(value : String) -> Void) {
        
        Alamofire.request(.POST, BIT.URL.ForceLogoutURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    // MARK: Get user balance, show it on another view
    
    /**
     *   getBalance function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func getBalance(success :(value : AnyObject) -> Void) {
        
        Alamofire.request(.GET, BIT.URL.UserOnlineURL)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    success(value: value)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
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