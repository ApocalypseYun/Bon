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
        super.viewDidLoad()
        
        tableView.isHidden = true
        //fetchVerifyCodeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchVerifyCodeImage()
    }
    
    func fetchVerifyCodeImage() {
        
        var imageURL = ""
        
        BonNetwork.get(BIT.URL.SelfService) { html in
            do {
                let doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
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
            Alamofire.request(imageURL, method: .get)
                .responseImage { (response) in
                    //print(response)
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.verifyCodeImageView.image = image
                    }
                    
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        verifyCodeTextField.resignFirstResponder()
    }
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        
        online = []
        
        let verifyCode = verifyCodeTextField.text!
        
        let parameters = [
            "_csrf": csrf,
            "LoginForm[username]": BonUserDefaults.username,
            "LoginForm[password]": BonUserDefaults.password,
            "LoginForm[verifyCode]": verifyCode,
            "login-button": ""
        ]
        
        Alamofire.request("http://10.0.0.55:8800", method: .post, parameters: parameters)
            .responseString { html in
                do {
                    let doc = try HTMLDocument(string: html.result.value!, encoding: String.Encoding.utf8)
                    self.onlineNumber = doc.xpath("/html/body//table/tr").count - 4
                    print(self.onlineNumber)
                    
                    for index in 2..<(2+self.onlineNumber) {
                        let ip = doc.xpath("/html/body//table/tr[\(index)]/td[2]/text()")
                        let loginTime = doc.xpath("/html/body//table/tr[\(index)]/td[4]/text()")
                        let id = doc.firstChild(xpath: "/html/body//table/tr[\(index)]/td[6]/a")!
                        print(id["id"]!)
                        print(ip[0])
                        print(loginTime[0])
                        self.online.append(Online(ip: ip[0].stringValue, time: loginTime[0].stringValue, id: id["id"]!))
                    }
                    self.tableView.reloadData()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tableView.isHidden = false
                    })
                    

                } catch let error {
                    print(error)
                }
                
        }

    }
    
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        fetchVerifyCodeImage()
    }
    
}

extension SelfServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(online.count)
        return online.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info") as UITableViewCell!
        
        let ipLabel = cell?.viewWithTag(101) as! UILabel
        ipLabel.text = online[(indexPath as NSIndexPath).row].ip
        
        let timeLabel = cell?.viewWithTag(102) as! UILabel
        timeLabel.text = online[(indexPath as NSIndexPath).row].time
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parameters = [
            "id": online[(indexPath as NSIndexPath).row].id
        ]
        
        Alamofire.request("http://10.0.0.55:8800/home/base/drop", method: .post, parameters: parameters)
            .responseString { (response) in
            print(response)
        }
    }
}
