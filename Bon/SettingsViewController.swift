//
//  SettingsViewController.swift
//  Bon
//
//  Created by Chris on 16/4/20.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var settingsTableView: UITableView!
    
    fileprivate let settingsUserCellIdentifier = "SettingsUserCell"
    fileprivate let settingsMoreCellIdentifier = "SettingsMoreCell"
    
    fileprivate var introduction: String {
        get {
            return "No Introduction yet."
        }
    }
    
    fileprivate let moreAnnotations: [[String: String]] = [
        [
            "name": NSLocalizedString("Notifications & Privacy", comment: ""),
            "segue": "showNotifications",
        ],
        [
            "name": NSLocalizedString("Feedback", comment: ""),
            "segue": "showFeedback",
        ],
        [
            "name": NSLocalizedString("About", comment: ""),
            "segue": "showAbout",
        ],
        ]
    
    fileprivate let introAttributes = [NSFontAttributeName: BonConfig.BonFont]
    
    deinit {
        
        settingsTableView?.delegate = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        title = NSLocalizedString("Settings", comment: "")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate enum Section: Int {
        case user = 0
        case more
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.user.rawValue:
            return 1
        case Section.more.rawValue:
            return moreAnnotations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
            
        case Section.user.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
            cell?.textLabel?.text = "User"
            return cell!
            
        case Section.more.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
            //let annotation = moreAnnotations[indexPath.row]
            //cell.annotationLabel.text = annotation["name"]
            cell?.textLabel?.text = "hello"
            return cell!
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
            
        case Section.user.rawValue:
            
//            let tableViewWidth = CGRectGetWidth(settingsTableView.bounds)
//            let introLabelMaxWidth = tableViewWidth - 161
//            
//            let rect = introduction.boundingRectWithSize(CGSize(width: introLabelMaxWidth, height: CGFloat(FLT_MAX)), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: introAttributes, context: nil)
//            
//            let height = max(78 + ceil(rect.height), 120)
            
            return 128
            
        case Section.more.rawValue:
            return 60
            
        default:
            return 0
        }
    }
  
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        defer {
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
//        
//        switch indexPath.section {
//            
//        case Section.User.rawValue:
//            performSegueWithIdentifier("showEditProfile", sender: nil)
//            
//        case Section.More.rawValue:
//            let annotation = moreAnnotations[indexPath.row]
//            
//            if let segue = annotation["segue"] {
//                performSegueWithIdentifier(segue, sender: nil)
//            }
//            
//        default:
//            break
//        }
//    }
}

