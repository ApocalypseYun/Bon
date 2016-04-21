////
////  AboutViewController.swift
////  Bon
////
////  Created by Chris on 16/4/20.
////  Copyright © 2016年 Chris. All rights reserved.
////
//
//import UIKit
//
//class AboutViewController: UIViewController {
//    
//    @IBOutlet private weak var aboutTableView: UITableView!
//    
//    private let aboutCellID = "AboutCell"
//    
//    private let aboutAnnotations: [String] = [
//        NSLocalizedString("Pods help Yep", comment: ""),
//        NSLocalizedString("Rate Yep on App Store", comment: ""),
//        NSLocalizedString("Terms of Service", comment: ""),
//        ]
//    
//    
//}
//
//extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
//    private enum Row: Int {
//        case Pods = 1
//        case Rate
//        case Terms
//    }
//
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return aboutAnnotations.count + 1
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        switch indexPath.row {
//        case 0:
//            return UITableViewCell()
//        default:
//            let cell = tableView.dequeueReusableCellWithIdentifier(aboutCellID)! as UITableViewCell
//            let annotation = aboutAnnotations[indexPath.row - 1]
//            //cell.annotationLabel.text = annotation
//            return cell
//        }
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            return 1
//        default:
//            //return rowHeight
//        }
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        defer {
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
//        
//        switch indexPath.row {
//        case Row.Pods.rawValue:
//            performSegueWithIdentifier("showPodsHelpYep", sender: nil)
//        case Row.Rate.rawValue:
//            //UIApplication.sharedApplication().openURL(NSURL(string: YepConfig.appURLString)!)
//        case Row.Terms.rawValue:
//            if let URL = NSURL(string: YepConfig.termsURLString) {
//                //yep_openURL(URL)
//            }
//        default:
//            break
//        }
//    }
//
//}
