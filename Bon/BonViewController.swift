//
//  ViewController.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift

class BonViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.secureTextEntry = true
            passwordTextField.delegate = self
        }
    }
    
    var uid = String();
    var username = String() {
        didSet {
            usernameTextField?.text? = username
        }
    }
    var password = String() {
        didSet {
            passwordTextField?.text? = password
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = initial("username")
        password = initial("password")
        uid = initial("uid")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func initial(key: String) -> String {
        let savedData = NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        if let data = savedData {
            return data
        } else {
            return ""
        }
    }
    
    
    func doLogin() {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        let parameters = [
            "username": username,
            "password": password.MD5,
            "drop": "0",
            "type": "1",
            "n": "100"
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
                        
                        let userInformation: [String: String] = {
                            var dict = Dictionary<String, String>()
                            for index in 0...7 {
                                dict[key[index]] = info[index]
                            }
                            return dict
                        }()
                        
                        self.saveUserInput()
                        print("\(userInformation["username"])")
                        print("Keep Live: \(value)")
                    }
                    
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
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
    
    func forceLogout() {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        let parameters = [
            "username": username,
            "password": password,
            "drop": "0",
            "type": "1",
            "n": "1"
        ]
        
        Alamofire.request(.POST, BIT.URL.ForceLogoutURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let string):
                    print("Force logout success with string: \(string)")
                    
                    if let value = response.result.value {
                        print("Force logout: \(value)")
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        saveUserInput()
        doLogin()
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        saveUserInput()
        doLogout()
    }
    
    @IBAction func forceLogoutButtonTapped(sender: AnyObject) {
        saveUserInput()
        forceLogout()
    }
    
    func saveUserInput() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(username, forKey: "username")
        defaults.setValue(password, forKey: "password")
        defaults.setValue(uid, forKey: "uid")
        defaults.synchronize()
    }
    
    
}
