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
        static let UserOnlineURL = "http://10.0.0.55/user_online.php"
        static let RadUserInfoURL = "http://10.0.0.55/cgi-bin/rad_user_info"
        static let SrunPortalURL = "http://10.0.0.55/cgi-bin/srun_portal"
    }
    
    static let LoginStatus: [String: String] = {
        
        var loginStatus = Dictionary<String, String>()
        loginStatus["user_tab_error"] = "The certification program does not start"
        loginStatus["username_error"] = "Username incorrect"
        loginStatus["non_auth_error"] = "You can directly access without authentication"
        loginStatus["password_error"] = "Password incorect"
        loginStatus["status_error"] = "The user is in arrears, please recharge as soon as possible"
        loginStatus["available_error"] = "The user has been disabled"
        loginStatus["ip_exist_error"] = "Your IP is not offline, please wait 2 minutes and try again"
        loginStatus["usernum_error"] = "The number of users has reached the upper limit"
        loginStatus["online_num_error"] = "The number of login the account has exceeded the limit of \n if the suspect account theft, please contact the webmaster"
        loginStatus["mode_error"] = "System has prohibited the use of WEB way to log in, please use the client"
        loginStatus["time_policy_error"] = "Connection is not allowed at the time of current session"
        loginStatus["flux_error"] = "Your flow is overdrawn"
        loginStatus["minutes_error"] = "Your time is overdrawn"
        loginStatus["ip_error"] = "Your IP address is not valid"
        loginStatus["mac_error"] = "Your MAC address is not valid"
        loginStatus["sync_error"] = "Your information has been modified, waiting for synchronization, please try again after 2 minutes"
        
//        loginStatus["user_tab_error"] = "认证程序未启动"
//        loginStatus["username_error"] = "用户名错误"
//        loginStatus["non_auth_error"] = "您无须认证，可直接上网"
//        loginStatus["password_error"] = "密码错误"
//        loginStatus["status_error"] = "用户已欠费，请尽快充值。"
//        loginStatus["available_error"] = "用户已禁用"
//        loginStatus["ip_exist_error"] = "您的IP尚未下线，请等待2分钟再试。"
//        loginStatus["usernum_error"] = "用户数已达上限"
//        loginStatus["online_num_error"] = "该帐号的登录人数已超过限额\n如果怀疑帐号被盗用，请联系管理员。"
//        loginStatus["mode_error"] = "系统已禁止WEB方式登录，请使用客户端"
//        loginStatus["time_policy_error"] = "当前时段不允许连接"
//        loginStatus["flux_error"] = "您的流量已超支"
//        loginStatus["minutes_error"] = "您的时长已超支"
//        loginStatus["ip_error"] = "您的IP地址不合法"
//        loginStatus["mac_error"] = "您的MAC地址不合法"
//        loginStatus["sync_error"] = "您的资料已修改，正在等待同步，请2分钟后再试。"
        
        return loginStatus
    }()
    
    static let LogoutStatus: [String: String] = {
        
        var logoutStatus = Dictionary<String, String>()
        logoutStatus["user_tab_error"] = "The certification program does not start"
        logoutStatus["username_error"] = "Username incorrect"
        logoutStatus["password_error"] = "Password incorrect"
        logoutStatus["logout_ok"] = "Logout success, please wait 1 minutes and login in。"
        logoutStatus["logout_error"] = "You are offline"

        
//        logoutStatus["user_tab_error"] = "认证程序未启动"
//        logoutStatus["username_error"] = "用户名错误"
//        logoutStatus["password_error"] = "密码错误"
//        logoutStatus["logout_ok"] = "注销成功，请等1分钟后登录。"
//        logoutStatus["logout_error"] = "您不在线上"
        
        return logoutStatus
    }()
    
    static let KeepLiveStatus: [String: String] = {
        var keepLiveStatus = Dictionary<String, String>()
        
        keepLiveStatus["status_error"] = "The user is in arrears, please recharge as soon as possible"
        keepLiveStatus["available_error"] = "The user has been disabled"
        keepLiveStatus["drop_error"] = "You have been forced offline"
        keepLiveStatus["flux_error"] = "Your flow is overdrawn"
        keepLiveStatus["minutes_error"] = "Your time is overdrawn"
        
//        keepLiveStatus["status_error"] = "您的帐户余额不足"
//        keepLiveStatus["available_error"] = "您的帐户被禁用"
//        keepLiveStatus["drop_error"] = "您被强制下线"
//        keepLiveStatus["flux_error"] = "您的流量已超支"
//        keepLiveStatus["minutes_error"] = "您的时长已超支"
        
        return keepLiveStatus
    }()
}
