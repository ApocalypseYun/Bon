//
//  LoginViewController.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
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
    
    var uid: String = ""
    var username: String = ""{
        didSet {
            usernameTextField?.text = username
            BonUserDefaults.username = username
        }
    }
    var password: String = ""{
        didSet {
            passwordTextField?.text = password
            BonUserDefaults.password = password
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = BonUserDefaults.username
        password = BonUserDefaults.password
        uid = BonUserDefaults.uid
        
        configureLoginInButton()
        configureTextFieldView()
        configureUsernameTextField()
        configurePasswordTextField()
        
    }
    
    // MARK: - Configuration
    
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
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
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
    
    // MARK: - Actions
    
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
        
        delay(2.0) { 
            self.loadingView.stopAnimating()
            self.loginButton.selected = false
            
            self.login()
        }
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        whiteActivityIndicator.startAnimating()
        loginButton.selected = true
        
        saveUserInput()
        
        delay(2.0) {
            self.whiteActivityIndicator.stopAnimating()
            self.loginButton.selected = false
            
            self.logout()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Login" {
            let balance = getBalance()
            let remainingData = getRemainingData()
            if balance != 0 {
                BonUserDefaults.remainingDataRate = remainingData / balance
            } else {
                BonUserDefaults.remainingDataRate = 0
            }
            print(BonUserDefaults.remainingDataRate)
        }
        
    }
    
    
    // MARK: - Network operation
    
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
        
        BonNetwork.login(parameters) { (value) in
            print(value)
            if value =~ Pattern.VALID_UID.description {
                self.uid = value
                print(self.uid)
                
                //let getUserInfoQueue = dispatch_queue_create("get_user_info_queue", nil)
                
                //self.getUserInfo()
//                dispatch_async(getUserInfoQueue, {
//                    self.getUserInfo()
//                    
//                    dispatch_async(dispatch_get_main_queue(), { })
//                })
                
                //self.keepLive()
                self.performSegueWithIdentifier("Login", sender: self)
            } else {
                print(value)
                BonAlert.alert(title: "Login Error", message: BIT.LoginErrorMessage[value], dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            }

        }
    }
    
    func getRemainingData() -> Double {
        
        let parameters = [
            "uid": uid
        ]
        
        BonNetwork.keepLive(parameters) { (value) in
            let info = value.componentsSeparatedByString(",")
            
//            let key = ["connectionTime", "inFlux", "outFlux", "remainFlux", "unknown1", "unknown2", "unknown3", "username"]
//            print(self.uid)
//            let userInfo: [String: String] = {
//                var userInfo = Dictionary<String, String>()
//                for index in 0...7 {
//                    userInfo[key[index]] = info[index]
//                }
//                return userInfo
//            }()
            let remainingData = Double(info[3])!
            //print(remainingData)
            print(remainingData/1024/1024/1024)
            BonUserDefaults.remainingData = remainingData / 1024 / 1024 / 1024
            self.saveUserInput()
            
            //print("Keep Live: \(userInfo)")
        }
        
        return BonUserDefaults.remainingData
    }
    
    
    
    func logout() {
        
        let parameters = [
            "uid": uid
        ]
        print("logout: \(uid)")
        BonNetwork.logout(parameters) { (value) in
            print("Logout: \(value)")
            
            if value == "logout_ok" {
                BonAlert.alert(title: "Logout Success", message: "Aha! You are offline now.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            } else {
                BonAlert.alert(title: "Logout Error", message: BIT.LogoutMessage[value], dismissTitle: "OK", inViewController: self, withDismissAction: nil)
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
        
        BonNetwork.forceLogout(parameters) { (value) in
            print("Force logout success with string: \(value)")
        }
    }
    
    // MARK: Get user balance, show it on another view
    
    func getBalance() -> Double {
        
        BonNetwork.getBalance(nil) { (value) in
            let detail = JSON(value!)
            print("Get balance success with string: \(detail)")
            let balance = detail["user_balance"].stringValue
            //let userBalance = detail.valueForKey("user_balance") as! String
            BonUserDefaults.balance = Double(balance)!
            print(balance)
        }
        return BonUserDefaults.balance
    }
    
    func getLoginState() {
        
        BonNetwork.getLoginState { (value) in
            print("Get Login State success with string: \(value)")
        }
    }
    
    func saveUserInput() {
        BonUserDefaults.saveUserDefaults(username, password: password, uid: uid)
    }
    
    func getUserInfo() {
        getRemainingData()
        getBalance()
    }

    
}
