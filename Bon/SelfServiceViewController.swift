//
//  SelfServiceViewController.swift
//  Bon
//
//  Created by Chris on 16/6/5.
//  Copyright © 2016年 Chris. All rights reserved.
//

import UIKit
import Fuzi
import Alamofire
import AlamofireImage

class Online {
    var ip: String
    var time: String
    var id: String
    
    init(ip: String, time: String, id: String) {
        self.ip = ip
        self.time = time
        self.id = id
    }

}

struct XPath {
    static let imageAnchor = "/html/body//img[@id]"
    static let csrf = "/html/head/meta[7]"
    static let ip = "/html/body//table/tr[\(index)]/td[2]/text()"
    static let loginTime = "/html/body//table/tr[\(index)]/td[4]/text()"
}

class SelfServiceViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var verifyCodeImageView: UIImageView!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var verifyCode: String = ""
    var csrf: String = ""
    var onlineNumber: Int = 0
    var online: [Online] = []
    
    override func viewDidLoad() {
        tableView.hidden = true
        fetchVerifyCodeImage()
    }
    
    func fetchVerifyCodeImage() {
        
        var imageURL = ""
        
        BonNetwork.get(BIT.URL.SelfService) { html in
            do {
                let doc = try HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
                let xpath = "/html/body//img[@id]"
                
                if let imageAnchor = doc.firstChild(xpath: xpath) {
                    print(imageAnchor["src"]!)
                    imageURL = BIT.URL.SelfService + imageAnchor["src"]!
                    print(imageURL)
                }
                if let csrf = doc.firstChild(xpath: XPath.csrf) {
                    print(csrf["content"]!)
                    self.csrf = csrf["content"]!
                }
                //print(html)
            } catch let error {
                print(error)
            }
            
            print(imageURL)
            Alamofire.request(.GET, imageURL)
                .responseImage { (response) in
                    //print(response)
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.verifyCodeImageView.image = image
                    }
                    
            }
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        online = []
        
        let verifyCode = verifyCodeTextField.text!
        
        let parameters = [
            "_csrf": csrf,
            "LoginForm[username]": BonUserDefaults.username,
            "LoginForm[password]": BonUserDefaults.password,
            "LoginForm[verifyCode]": verifyCode,
            "login-button": ""
        ]
        
        Alamofire.request(.POST, "http://10.0.0.55:8800", parameters: parameters)
            .responseString { html in
                do {
                    let doc = try HTMLDocument(string: html.result.value!, encoding: NSUTF8StringEncoding)
                    self.onlineNumber = doc.xpath("/html/body//table/tr").count - 4
                    print(self.onlineNumber)
                    
                    for index in 2..<(2+self.onlineNumber) {
                        let ip = doc.xpath("/html/body//table/tr[\(index)]/td[2]/text()")
                        let loginTime = doc.xpath("/html/body//table/tr[\(index)]/td[4]/text()")
                        let id = doc.firstChild(xpath: "/html/body//table/tr[\(index)]/td[6]/a")!
                        print(id["id"]!)
                        print(ip[0]!)
                        print(loginTime[0]!)
                        self.online.append(Online(ip: ip[0]!.stringValue, time: loginTime[0]!.stringValue, id: id["id"]!))
                    }
                    self.tableView.reloadData()
                    UIView.animateWithDuration(0.5, animations: {
                        self.tableView.hidden = false
                    })
                    

                } catch let error {
                    print(error)
                }
                
        }

    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        fetchVerifyCodeImage()
    }
    
}

extension SelfServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(online.count)
        return online.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("info") as UITableViewCell!
        
        let ipLabel = cell.viewWithTag(101) as! UILabel
        ipLabel.text = online[indexPath.row].ip
        
        let timeLabel = cell.viewWithTag(102) as! UILabel
        timeLabel.text = online[indexPath.row].time
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let parameters = [
            "id": online[indexPath.row].id
        ]
        
        Alamofire.request(.POST, "http://10.0.0.55:8800/home/base/drop", parameters: parameters)
            .responseString { (response) in
            print(response)
        }
    }
}