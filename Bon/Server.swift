//
//  Server.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation
import Alamofire

class Server {
    
    var uid: String = ""
    
    func doLogin() {
        
        let username = "1120141755"
        let password = "039036".MD5
        
        let parameters = [
            "username" : username,
            "password" : password,
            "drop" : "0",
            "type" : "1",
            "n" : "100"
        ]
        
        //        let headers = [
        //            "Content-Type": "application/x-www-form-urlencoded"
        //        ]
        
        Alamofire.request(.POST, BIT.URL.DoLoginURL, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .Success(let string):
                    print("Success with JSON: \(string)")
                    
                    if let uid = Int(string) {
                        print(uid)
                        
                        if let value = response.result.value {
                            print("JSON: \(value)")
                            self.uid = value
                        }
                        
                        self.keepLive()
                        
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
        
    }
    
    func keepLive() {
        
        let parameter = [
            "uid": self.uid
        ]
        
        Alamofire.request(.POST, BIT.URL.KeepLiveURL, parameters: parameter)
            .responseString { response in
                switch response.result {
                case .Success(let string):
                    
                    print("Success with string: \(string)")
                    
                    if let value = response.result.value {
                        let info = value.componentsSeparatedByString(",")
                        print(info);
                        
                        let key = ["connectionTime", "inFlow", "outFlow", "usableFlow", "unknown1", "unknown2", "unknown3", "username"]
                        
                        let userInfo: [String: String] = {
                            var dict = Dictionary<String, String>()
                            for index in 0...7 {
                                dict[key[index]] = info[index]
                            }
                            return dict
                        }()
                        
                        print("\(userInfo["username"])")
                        print("Keep Live: \(value)")
                    }
                    
                    //example if there is an id
                    //let userId = response.objectForKey("id")!
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
        
    }
    func doLogout() {
        let parameter = [
            "uid": uid
        ]
        Alamofire.request(.POST, BIT.URL.DoLogoutURL, parameters: parameter)
            .responseString { response in
                switch response.result {
                case .Success(let string):
                    print("Success with string: \(string)")
                    
                    if let value = response.result.value {
                        
                        print("Logout: \(value)")
                    }
                    
                    //example if there is an id
                    //let userId = response.objectForKey("id")!
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }

}