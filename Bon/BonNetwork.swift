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
    
    //var alamoFireManager = Alamofire.Manager.sharedInstance
    
    /**
     *   login function
     *   url : url
     *   params : JSON
     *   success : Request success callback function
     */
    
    static func post(_ parameters: [String : String]?, success: @escaping (_ value: String) -> Void) {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(BIT.URL.AuthActionURL, method: .post, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .success(let value):
                    success(value)
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
    }

    
    static func post(_ parameters: [String : String]?, success: @escaping (_ value: String) -> Void, fail: @escaping (_ error : Any) -> Void) {
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(BIT.URL.AuthActionURL, method: .post, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .success(let value):
                    success(value)
                    
                case .failure(let error):
                    fail(error: error)
                }
        }
        
        
    }
    
    static func get(_ URL: String, success: @escaping (_ value: String) -> Void) {
        
        Alamofire.request(URL, method: .get)
            .responseString{ response in
                switch response.result {
                case .success(let value):
                    success(value)
                    
                case .failure(let error):
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
    
    static func getLoginState(_ success :@escaping (_ value : String) -> Void) {
        
        Alamofire.request(BIT.URL.RadUserInfoURL, method: .get)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    success(value)
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
    }
    
    
}
