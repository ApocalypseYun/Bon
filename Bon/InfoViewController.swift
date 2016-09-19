//
//  InfoViewController.swift
//  Bon
//
//  Created by Chris on 16/4/22.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usedDataLabel: UILabel!
    @IBOutlet weak var usedTimeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var dailyAvailableDataLabel: UILabel!
    
    var digit = 0;
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var usedData: Double = 0.0 {
        didSet {
            usedDataLabel.text = BonFormat.formatData(usedData)
            //usedData = usedData / (1024 * 1024 * 1024)
        }
    }
    
    var balance: Double = 0.0 {
        didSet {
            balanceLabel.text = String(format: "%.2f", balance) + "G"
        }
    }
    
    var seconds: Int = 0 {
        didSet {
            let usedTime = BonFormat.formatTime(seconds)
            usedTimeLabel.text = usedTime
        }
    }
    
    var dailyAvailableData: Double = 0.0 {
        didSet {
            dailyAvailableDataLabel.text = BonFormat.formatData(dailyAvailableData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUserInfo()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        
        let parameters = [
            "action": "auto_logout"
        ]
        BonNetwork.post(parameters) { (value) in
            BonAlert.alert(title: "Logout Success", message: "Aha! You are offline now.", dismissTitle: "OK", inViewController: self, withDismissAction: nil)
        }
        
        delay(2) { 
            self.getOnlineInfo()
        }
        
    }
    
    func getOnlineInfo() {
        let parameters = [
            "action": "get_online_info",
            //"user_ip": "10.194.182.127"
        ]
        BonNetwork.post(parameters) { (value) in
            print(value)
        }
    }
    
    func updateTime() {
        seconds = seconds + 1
//        let date = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.timeStyle = .MediumStyle
//        timeLabel.text = formatter.stringFromDate(date)
    }
    
    func showUserInfo() {
        username = BonUserDefaults.username
        usedData = BonUserDefaults.usedData
        seconds = BonUserDefaults.seconds
        balance = BonUserDefaults.balance
        
        dailyAvailableData = BonFormat.getDailyAvailableData(balance, usedData: usedData)
    }
    
}

