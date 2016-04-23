//
//  TimeViewController.swift
//  Bon
//
//  Created by Chris on 16/4/22.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import NumberMorphView

class TimeViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var h0: NumberMorphView!
//    @IBOutlet weak var h1: NumberMorphView!
//    @IBOutlet weak var m0: NumberMorphView!
//    @IBOutlet weak var m1: NumberMorphView!
//    @IBOutlet weak var s0: NumberMorphView!
//    @IBOutlet weak var s1: NumberMorphView!
    
//    @IBOutlet weak var n1: NumberMorphView!
//    @IBOutlet weak var n2: NumberMorphView!
//    @IBOutlet weak var n3: NumberMorphView!
//    @IBOutlet weak var n4: NumberMorphView!
//    @IBOutlet weak var n5: NumberMorphView!
//    @IBOutlet weak var n6: NumberMorphView!
    
    var digit = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true);
//        n1.interpolator = NumberMorphView.LinearInterpolator();
//        n2.interpolator = NumberMorphView.OvershootInterpolator();
//        n3.interpolator = NumberMorphView.SpringInterpolator();
//        n4.interpolator = NumberMorphView.BounceInterpolator();
//        n5.interpolator = NumberMorphView.AnticipateOvershootInterpolator();
//        n6.interpolator = NumberMorphView.CubicHermiteInterpolator();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true);
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
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        timeLabel.text = formatter.stringFromDate(date)
//        let components = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date);
//        var hour = components?.hour ?? 0;
//        let minute = components?.minute ?? 0;
//        let second = components?.second ?? 0;
//        
//        if hour > 12 {
//            hour -= 12;
//        }
        
//        if hour / 10 != h1.currentDigit || h1.currentDigit == 0 {
//            h1.nextDigit = hour / 10;
//        }
//        if hour % 10 != h0.currentDigit
//            || h0.currentDigit == 0 {
//            h0.nextDigit = hour % 10;
//        }
//        
//        if minute / 10 != m1.currentDigit || m1.currentDigit == 0 {
//            m1.nextDigit = minute / 10;
//        }
//        if minute % 10 != m0.currentDigit || m0.currentDigit == 0 {
//            m0.nextDigit = minute % 10;
//        }
//        
//        if second / 10 != s1.currentDigit || s1.currentDigit == 0 {
//            s1.nextDigit = second / 10;
//        }
//        if second % 10 != s0.currentDigit || s0.currentDigit == 0 {
//            s0.nextDigit = second % 10;
//        }
        
//        n1.nextDigit = digit;
//        n2.nextDigit = digit;
//        n3.nextDigit = digit;
//        n4.nextDigit = digit;
//        n5.nextDigit = digit;
//        n6.nextDigit = digit;
//        digit = (digit + 1) % 10;
    }
    
}

