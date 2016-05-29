//
//  LoginViewController.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

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
        
        loginButton.setTitleColor(UIColor.bonTintColor(), forState: .Highlighted)
        loginButton.setTitleColor(UIColor.bonTintColor(), forState: .Selected)
        
        username = BonUserDefaults.username
        password = BonUserDefaults.password
        
        configure()
        
    }
    
    // MARK: - Animation
    
    func moveLoginContentViews() {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) {
            self.loginContentViewCenterY.constant = -100
            self.logoutButtonTop.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    func moveBackLoginContentViews() {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5) {
            self.loginContentViewCenterY.constant = 0
            self.logoutButtonTop.constant = 127
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: Configuration
    
    func configure() {
        textFieldView.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
        usernameTextField.delegate = self
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
        //loginButton.tintColor = UIColor.bonTintColor()
        
        self.login()
//        delay(2.0) { 
//            //self.loadingView.stopAnimating()
//            //self.loginButton.selected = false
//            //self.loginButton.tintColor = UIColor.whiteColor()
//            //self.login()
//        }
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        whiteActivityIndicator.startAnimating()
        
        //saveUserInput()
        
        delay(2.0) {
            self.forceLogout()
        }
        
    }
    
    @IBAction func onHelpCenterButton(sender: AnyObject) {
        let url : NSURL = NSURL(string: BIT.URL.HelpCenter)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Login" {
        }
        
    }
    
    
    // MARK: - Network operation
    
    func login() {
        
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        let parameters = [
            "action": "login",
            "username": username,
            "password": password,
            "ac_id": "1",
            "user_ip": "",
            "nas_ip": "",
            "user_mac": "",
            "save_me": "1",
            "ajax": "1"
        ]
        
        BonNetwork.post(parameters, success: { (value) in
            print(value)
            if value.containsString("login_ok,") {
                delay(1) {
                    self.getOnlineInfo()
                    self.loadingView.stopAnimating()
                    self.loginButton.selected = false
                    self.performSegueWithIdentifier("Login", sender: self)
                }
            } else {
                self.loadingView.stopAnimating()
                self.loginButton.selected = false
                BonAlert.alertSorry(message: "Login error", inViewController: self)
                // E2616: Arrearage users.(已欠费)
            }
            }) { (error) in
                self.loadingView.stopAnimating()
                self.loginButton.selected = false
                BonAlert.alertSorry(message: "The request timed out.", inViewController: self)
        }
    }
//                //let getUserInfoQueue = dispatch_queue_create("get_user_info_queue", nil)
//                
//                //self.getUserInfo()
////                dispatch_async(getUserInfoQueue, {
////                    self.getUserInfo()
////                    
////                    dispatch_async(dispatch_get_main_queue(), { })
////                })
    
    
    // MARK : - logout
    
    func logout() {
        
        let parameters = [
            "action": "auto_logout"
        ]
        BonNetwork.post(parameters) { (value) in
            BonAlert.alert(title: "Logout Success", message: "Aha! You are offline now.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
        }
    }
    
    
    // MARK : - forcelogout
    
    func forceLogout() {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        
        let parameters = [
            "action": "logout",
            "username": username,
            "password": password,
            "ajax": "1"
        ]
        
        BonNetwork.post(parameters) { (value) in
            print(value)
            self.whiteActivityIndicator.stopAnimating()
            BonAlert.alert(title: "Logout Success", message: "Aha! You are offline now.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
            //if value.containsString("logout_ok")
        }
        
        ///^login_ok,/
        //action=login&username=1120141755&password=039026&ac_id=1&user_ip=&nas_ip=&user_mac=&save_me=1&ajax=1

        
        // "582023371"
        // "691918"
    }
    
    // MARK : - get online info
    
    func getOnlineInfo() {
        
        let parameters = [
            "action": "get_online_info",
            //"user_ip": "10.194.182.127"
        ]
        
        BonNetwork.post(parameters) { (value) in
            print(value)
            let info = value.componentsSeparatedByString(",")
            
            let usedData = Double(info[0])!
            BonUserDefaults.usedData = usedData
            
            let seconds = Int(info[1])!
            BonUserDefaults.seconds = seconds
            
            let balance = Double(info[2])!
            BonUserDefaults.balance = balance
            
        }
        
        //      Data, time, balance, username
        //SUCCESS: 0,2656,1.53,D0331191353C,1120141755,0
    }
    
}
