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
    
    let loginViewController = LoginViewController()
    
    var uid = String();
    var username = String() {
        didSet {
            loginViewController.usernameTextField?.text? = username
        }
    }
    var password = String() {
        didSet {
            loginViewController.passwordTextField?.text? = password
        }
    }

    
    func login() {
        
        let parameters = [
            "username": username,
            "password": password.MD5,
            "drop": "0",
            "type": "1",
            "n": "100"
        ]
        
        Alamofire.request(.POST, BIT.URL.DoLoginURL, parameters: parameters)
            .responseString{ response in
                switch response.result {
                case .Success(let value):
                    if Int(value) != nil {
                        self.uid = value
                        self.keepLive()
                        self.loginViewController.performSegueWithIdentifier("Login", sender: self.loginViewController)
                    } else {
                        
//                        let alertController = UIAlertController(title: "Login Error", message: BIT.LoginStatus[value], preferredStyle: .Alert)
//                        
//                        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                        
//                        alertController.addAction(action)
//                        
//                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
        
    }
    
    func keepLive() {
        
        let parameters = [
            "uid": self.uid
        ]
        
        Alamofire.request(.POST, BIT.URL.KeepLiveURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    
                    let info = value.componentsSeparatedByString(",")
                    
                    let key = ["connectionTime", "inFlow", "outFlow", "usableFlow", "unknown1", "unknown2", "unknown3", "username"]
                    
                    let userInfo: [String: String] = {
                        var userInfo = Dictionary<String, String>()
                        for index in 0...7 {
                            userInfo[key[index]] = info[index]
                        }
                        return userInfo
                    }()
                    
                    self.loginViewController.saveUserInput()
                    
                    print("Keep Live: \(userInfo)")
                    
//                    let alertController = UIAlertController(title: "Login Success", message: "Congratulations! You are online now.", preferredStyle: .Alert)
//                    
//                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                    
//                    alertController.addAction(action)
//                    
//                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
        
    }
    
    
//    func logout() {
//        
//        let parameters = [
//            "uid": uid
//        ]
//        
//        Alamofire.request(.POST, BIT.URL.DoLogoutURL, parameters: parameters)
//            .responseString { response in
//                switch response.result {
//                case .Success(let value):
//                    
//                    print("Logout: \(value)")
//                    
//                    var alertController = UIAlertController()
//                    if value == "logout_ok" {
//                        alertController = UIAlertController(title: "Logout Success", message: "Aha! You are offline now.", preferredStyle: .Alert)
//                    } else {
//                        alertController = UIAlertController(title: "Logout Error", message: BIT.LogoutStatus[value], preferredStyle: .Alert)
//                    }
//                    
//                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                    alertController.addAction(action)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                    
//                case .Failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//        }
//        
//    }
//    
//    // FIXME: It doesn't work well
//    
//    func forceLogout() {
//        username = usernameTextField.text!
//        password = passwordTextField.text!
//        
//        // "582023371"
//        // "691918"
//        let parameters = [
//            "username": username,
//            "password": password,
//            //            "drop": "0",
//            //            "type": "1",
//            //            "n": "1"
//        ]
//        print(parameters)
//        
//        //        let headers = [
//        //            "Content-Type": "application/x-www-form-urlencoded",
//        ////            "Accept": "application/vnd.lichess.v1+json",
//        ////            "X-Requested-With": "XMLHttpRequest",
//        //            "User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
//        //            //"user-agent": "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)"
//        //        ]
//        
//        Alamofire.request(.POST, BIT.URL.ForceLogoutURL, parameters: parameters)
//            .responseString { response in
//                switch response.result {
//                case .Success(let string):
//                    print("Force logout success with string: \(string)")
//                    print(response.debugDescription)
//                    if let value = response.result.value {
//                        print("Force logout: \(value)")
//                    }
//                    
//                case .Failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//        }
//    }
//    
//    // MARK: Get user balance, show it on another view
//    func getBalance() {
//        
//        //        {
//        //            "buy_mbytes" = "0.00";
//        //            "buy_minutes" = "<null>";
//        //            charge = "10.00";
//        //            client = WEB;
//        //            fid = 11668;
//        //            "flux_long" = "9.00G";
//        //            "flux_long1" = B;
//        //            "flux_long6" = B;
//        //            "free_in_bytes" = 0B;
//        //            "free_out_bytes" = 0B;
//        //            ipv = 4;
//        //            limit = 0;
//        //            "month_fee" = "10.00";
//        //            "remain_fee" = "1.53";
//        //            "remain_flux" = "2,530.89M";
//        //            "remain_timelong" = "<null>";
//        //            speed = 0;
//        //            "time_long" = 0;
//        //            "time_long1" = 0;
//        //            "time_long6" = 0;
//        //            uid = 44064;
//        //            "user_balance" = "11.53";
//        //            "user_in_bytes" = 0B;
//        //            "user_ip" = "10.194.25.196";
//        //            "user_login_name" = 1120141755;
//        //            "user_login_time" = "2016-04-18 09:00:47";
//        //            "user_out_bytes" = 0B;
//        //        }
//        
//        Alamofire.request(.GET, BIT.URL.UserOnlineURL)
//            .responseJSON { response in
//                switch response.result {
//                case .Success(let JSON):
//                    let response = JSON as! NSDictionary
//                    print("Get balance success with string: \(response)")
//                    
//                    //                    if let value = response.result.value {
//                    //                        print("Force logout: \(value)")
//                    //                    }
//                    
//                case .Failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//        }
//    }
//    
//    func getLoginState() {
//        
//        Alamofire.request(.POST, BIT.URL.RadUserInfoURL)
//            .responseString { response in
//                switch response.result {
//                case .Success(let Json):
//                    print("Get Login State success with string: \(Json)")
//                    
//                    //                    if let value = response.result.value {
//                    //                        print("Login State: \(value)")
//                    //                    }
//                    
//                case .Failure(let error):
//                    print("Request failed with error: \(error)")
//                }
//                
//        }
//    }

}