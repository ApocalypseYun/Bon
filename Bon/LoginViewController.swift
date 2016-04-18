//
//  LoginViewController.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import CryptoSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet var loginContentView: UIView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var textFieldView: UIView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var whiteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logoutButtonTop: NSLayoutConstraint!
    @IBOutlet weak var loginContentViewCenterY: NSLayoutConstraint!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = initial("username")
        password = initial("password")
        uid = initial("uid")
        
        configureLoginInButton()
        configureTextFieldView()
        configureUsernameTextField()
        configurePasswordTextField()
        
    }
    
    // MARK: Configuration
    
    func moveLoginContentViews() {
        UIView.animateWithDuration(10.0) {
            self.loginContentViewCenterY.constant = -100
            self.logoutButtonTop.constant = 50
        }
    }
    
    func moveBackLoginContentViews() {
        UIView.animateWithDuration(10.0) {
            self.loginContentViewCenterY.constant = 0
            self.logoutButtonTop.constant = 127
        }
    }
    
    
    // MARK: Configuration
    
    func configureTextFieldView() {
        textFieldView.layer.cornerRadius = 3
    }
    
    func configureLoginInButton() {
        loginButton.layer.cornerRadius = 3
        
    }
    
    func configureUsernameTextField() {
        usernameTextField.delegate = self
    }
    
    func configurePasswordTextField() {
        passwordTextField.delegate = self
    }
    
    // Function to create a delay method that is easy to re-use
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //print("TextFieldChanged", terminator: "")
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            
            loginButton.enabled = true
        } else {
            loginButton.enabled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Actions
    
    @IBAction func onUsernameTextField(sender: AnyObject) {
        moveLoginContentViews()
        
    }
    
    @IBAction func onPasswordTextField(sender: AnyObject) {
        moveLoginContentViews()
    }
    
    @IBAction func endEditing(sender: AnyObject) {
        view.endEditing(true)
        moveBackLoginContentViews()
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        loadingView.startAnimating()
        loginButton.selected = true
        
        saveUserInput()
        
        delay(2.0, closure: {
            self.loadingView.stopAnimating()
            self.loginButton.selected = false
            
            self.login()
            //self.userEmailAndPasswordCheck()
        })
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        whiteActivityIndicator.startAnimating()
        loginButton.selected = true
        
        saveUserInput()
        
        delay(2.0, closure: {
            self.whiteActivityIndicator.stopAnimating()
            self.loginButton.selected = false
            
            self.logout()
            //self.userEmailAndPasswordCheck()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogIn" {
            
        }
        
    }
    
    /*
     // #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func initial(key: String) -> String {
        let savedData = NSUserDefaults.standardUserDefaults().objectForKey(key) as? String
        if let data = savedData {
            loginButton.enabled = true
            return data
        } else {
            loginButton.enabled = false
            return ""
        }
    }
    
    
    func login() {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
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
                        self.performSegueWithIdentifier("Login", sender: self)
                    } else {
                        
                        let alertController = UIAlertController(title: "Login Error", message: BIT.LoginStatus[value], preferredStyle: .Alert)
                        
                        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        
                        alertController.addAction(action)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
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
                    
                    self.saveUserInput()
                    
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
    
    
    func logout() {
        
        let parameters = [
            "uid": uid
        ]
        
        Alamofire.request(.POST, BIT.URL.DoLogoutURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let value):
                    
                    print("Logout: \(value)")
                    
                    var alertController = UIAlertController()
                    if value == "logout_ok" {
                        alertController = UIAlertController(title: "Logout Success", message: "Aha! You are offline now.", preferredStyle: .Alert)
                    } else {
                        alertController = UIAlertController(title: "Logout Error", message: BIT.LogoutStatus[value], preferredStyle: .Alert)
                    }
                    
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }
    
    // FIXME: It doesn't work well
    
    func forceLogout() {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        // "582023371"
        // "691918"
        let parameters = [
            "username": username,
            "password": password,
            //            "drop": "0",
            //            "type": "1",
            //            "n": "1"
        ]
        print(parameters)
        
        //        let headers = [
        //            "Content-Type": "application/x-www-form-urlencoded",
        ////            "Accept": "application/vnd.lichess.v1+json",
        ////            "X-Requested-With": "XMLHttpRequest",
        //            "User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        //            //"user-agent": "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)"
        //        ]
        
        Alamofire.request(.POST, BIT.URL.ForceLogoutURL, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .Success(let string):
                    print("Force logout success with string: \(string)")
                    print(response.debugDescription)
                    if let value = response.result.value {
                        print("Force logout: \(value)")
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    // MARK: Get user balance, show it on another view
    func getBalance() {
        
        //        {
        //            "buy_mbytes" = "0.00";
        //            "buy_minutes" = "<null>";
        //            charge = "10.00";
        //            client = WEB;
        //            fid = 11668;
        //            "flux_long" = "9.00G";
        //            "flux_long1" = B;
        //            "flux_long6" = B;
        //            "free_in_bytes" = 0B;
        //            "free_out_bytes" = 0B;
        //            ipv = 4;
        //            limit = 0;
        //            "month_fee" = "10.00";
        //            "remain_fee" = "1.53";
        //            "remain_flux" = "2,530.89M";
        //            "remain_timelong" = "<null>";
        //            speed = 0;
        //            "time_long" = 0;
        //            "time_long1" = 0;
        //            "time_long6" = 0;
        //            uid = 44064;
        //            "user_balance" = "11.53";
        //            "user_in_bytes" = 0B;
        //            "user_ip" = "10.194.25.196";
        //            "user_login_name" = 1120141755;
        //            "user_login_time" = "2016-04-18 09:00:47";
        //            "user_out_bytes" = 0B;
        //        }
        
        Alamofire.request(.GET, BIT.URL.UserOnlineURL)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    let response = JSON as! NSDictionary
                    print("Get balance success with string: \(response)")
                    
                    //                    if let value = response.result.value {
                    //                        print("Force logout: \(value)")
                    //                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func getLoginState() {
        
        Alamofire.request(.POST, BIT.URL.RadUserInfoURL)
            .responseString { response in
                switch response.result {
                case .Success(let Json):
                    print("Get Login State success with string: \(Json)")
                    
                    //                    if let value = response.result.value {
                    //                        print("Login State: \(value)")
                    //                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
                
        }
    }
    
    func saveUserInput() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(username, forKey: "username")
        defaults.setValue(password, forKey: "password")
        defaults.setValue(uid, forKey: "uid")
        defaults.synchronize()
    }
    
}
