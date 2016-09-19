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
        
        loginButton.setTitleColor(UIColor.bonTintColor(), for: .highlighted)
        loginButton.setTitleColor(UIColor.bonTintColor(), for: .selected)
        
        username = BonUserDefaults.username
        password = BonUserDefaults.password
        
        configure()
        
    }
    
    // MARK: - Animation
    
    func moveLoginContentViews() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.loginContentViewCenterY.constant = -100
            self.logoutButtonTop.constant = 50
            self.view.layoutIfNeeded()
        }) 
    }
    
    func moveBackLoginContentViews() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.loginContentViewCenterY.constant = 0
            self.logoutButtonTop.constant = 127
            self.view.layoutIfNeeded()
        }) 
    }
    
    
    // MARK: Configuration
    
    func configure() {
        textFieldView.layer.cornerRadius = 3
        loginButton.layer.cornerRadius = 3
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func onUsernameTextField(_ sender: AnyObject) {
        moveLoginContentViews()
        
    }
    
    @IBAction func onPasswordTextField(_ sender: AnyObject) {
        moveLoginContentViews()
    }
    
    @IBAction func endEditing(_ sender: AnyObject) {
        view.endEditing(true)
        moveBackLoginContentViews()
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        loadingView.startAnimating()
        loginButton.isSelected = true
        //loginButton.tintColor = UIColor.bonTintColor()
        
        self.login()
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        whiteActivityIndicator.startAnimating()
        
        //saveUserInput()
        
        delay(2.0) {
            self.forceLogout()
        }
        
    }
    
    @IBAction func onHelpCenterButton(_ sender: AnyObject) {
        let url : URL = URL(string: BIT.URL.SelfService)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            if value.contains("login_ok,") {
                delay(1) {
                    self.getOnlineInfo()
                    self.loadingView.stopAnimating()
                    self.loginButton.isSelected = false
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            } else {
                self.loadingView.stopAnimating()
                self.loginButton.isSelected = false
                BonAlert.alertSorry(message: "Login error", inViewController: self)
                // E2616: Arrearage users.(已欠费)
            }
            }) { (error) in
                self.loadingView.stopAnimating()
                self.loginButton.isSelected = false
                BonAlert.alertSorry(message: "The request timed out.", inViewController: self)
        }
    }
    
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
        
    }
    
    // MARK : - get online info
    
    func getOnlineInfo() {
        
        let parameters = [
            "action": "get_online_info",
        ]
        
        BonNetwork.post(parameters) { (value) in
            print(value)
            let info = value.components(separatedBy: ",")
            
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
