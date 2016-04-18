//
//  BITer.swift
//  Bon
//
//  Created by Chris on 16/4/17.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation

class BIT {
    
    struct URL {
        static let DoLoginURL = "http://10.0.0.55/cgi-bin/do_login"
        static let KeepLiveURL = "http://10.0.0.55/cgi-bin/keeplive"
        static let DoLogoutURL = "http://10.0.0.55/cgi-bin/do_logout"
        static let ForceLogoutURL = "http://10.0.0.55/cgi-bin/force_logout"
    }
    
    static let LoginStatus: [String: String] = {
        var loginStatus = Dictionary<String, String>()
        loginStatus["user_tab_error"] = "认证程序未启动"
        loginStatus["username_error"] = "用户名错误"
        loginStatus["non_auth_error"] = "您无须认证，可直接上网"
        loginStatus["password_error"] = "密码错误"
        loginStatus["status_error"] = "用户已欠费，请尽快充值。"
        loginStatus["available_error"] = "用户已禁用"
        loginStatus["ip_exist_error"] = "您的IP尚未下线，请等待2分钟再试。"
        loginStatus["usernum_error"] = "用户数已达上限"
        loginStatus["online_num_error"] = "该帐号的登录人数已超过限额\n如果怀疑帐号被盗用，请联系管理员。"
        loginStatus["mode_error"] = "系统已禁止WEB方式登录，请使用客户端"
        loginStatus["time_policy_error"] = "当前时段不允许连接"
        loginStatus["flux_error"] = "您的流量已超支"
        loginStatus["minutes_error"] = "您的时长已超支"
        loginStatus["ip_error"] = "您的IP地址不合法"
        loginStatus["mac_error"] = "您的MAC地址不合法"
        loginStatus["sync_error"] = "您的资料已修改，正在等待同步，请2分钟后再试。"
        
        return loginStatus
    }()
    
    static let LogoutStatus: [String: String] = {
        var logoutStatus = Dictionary<String, String>()
        logoutStatus["user_tab_error"] = "认证程序未启动"
        logoutStatus["username_error"] = "用户名错误"
        logoutStatus["password_error"] = "密码错误"
        logoutStatus["logout_ok"] = "注销成功，请等1分钟后登录。"
        logoutStatus["logout_error"] = "您不在线上"
        
        return logoutStatus
    }()
    
    static let KeepLiveStatus: [String: String] = {
        var keepLiveStatus = Dictionary<String, String>()
        keepLiveStatus["status_error"] = "您的帐户余额不足"
        keepLiveStatus["available_error"] = "您的帐户被禁用"
        keepLiveStatus["drop_error"] = "您被强制下线"
        keepLiveStatus["flux_error"] = "您的流量已超支"
        keepLiveStatus["minutes_error"] = "您的时长已超支"
        
        return keepLiveStatus
    }()
}

extension String {
    var MD5: String {
        let md5 = self.md5()
        let start =  md5.startIndex.advancedBy(8)
        let end = md5.endIndex.advancedBy(-8)
        let range = Range<String.Index>(start..<end)
        
        return md5.substringWithRange(range)
    }
}