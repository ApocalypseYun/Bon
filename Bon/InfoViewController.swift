//
//  InfoViewController.swift
//  Bon
//
//  Created by Chris on 16/4/22.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usedDataLabel: UILabel!
    @IBOutlet weak var usedTimeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    var digit = 0;
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var usedData: Double = 0.0 {
        didSet {
            usedDataLabel.text = formatData(usedData)
            usedData = usedData / (1024 * 1024 * 1024)
        }
    }
    
    var balance: Double = 0.0 {
        didSet {
            balanceLabel.text = String(format: "%.2f", balance) + "G"
        }
    }
    
    var seconds: Int = 0 {
        didSet {
            let usedTime = formatTime(seconds)
            usedTimeLabel.text = usedTime
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.hidden = true
        showUserInfo()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        
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
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        timeLabel.text = formatter.stringFromDate(date)
    }
    
    func showUserInfo() {
        username = BonUserDefaults.username
        usedData = BonUserDefaults.usedData
        seconds = BonUserDefaults.seconds
        balance = BonUserDefaults.balance
    }
    
    func formatData(byte: Double) -> String {
        
        if byte > 1024 * 1024 {
            let megabyte = String(format: "%.2f", byte / (1024 * 1024)) + "M"
            return megabyte
        } else if byte > 1024 {
            let kilobyte = String(format: "%.2f", byte / 1024) + "K"
            return kilobyte
        } else {
            let byte = String(format: "%.2f", byte) + "b"
            return byte
        }
    }
    
    func formatTime(seconds: Int) -> String {
        
        let hour = String(format: "%02d", seconds / 3600)
        let minute = String(format: "%02d", (seconds % 3600) / 60)
        let second = String(format: "%02d", seconds % 3600 % 60)
        
        let usedTime = hour + ":" + minute + ":" + second
        return usedTime
    }

}
