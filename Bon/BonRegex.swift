//
//  BonRegex.swift
//  Bon
//
//  Created by Chris on 16/4/19.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation

public enum Pattern: String, CustomStringConvertible {
    case VALID_UID = "^login_ok,"
    //case VALID_UID = "^[\\d]+$"
    case VALID_KEEPLIVE_STATUS = "^[\\d]+,[\\d]+,[\\d]+,[\\d]+"
    case VALID_BALANCE = "\"remain_flux\":\"([\\d,\\.]+)M\""
    case VALID_USED_IN = "\"user_in_bytes\":\"([\\d,\\.]+)M\""
    case VALID_USED_OUT = "\"user_out_bytes\":\"([\\d,\\.]+)M\""
    case VALID_COMMA = ","
    
    public var description: String {
        return self.rawValue
    }
}

struct BonRegex {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matchesInString(input,
                                            options: [],
                                            range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
    
    
}

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try BonRegex(rhs).match(lhs)
    } catch _ {
        return false
    }
}

//let mailPattern =
//"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//
//let matcher: RegexHelper
//do {
//    matcher = try RegexHelper(mailPattern)
//}
//
//let maybeMailAddress = "onev@onevcat.com"
//
//if matcher.match(maybeMailAddress) {
//    print("有效的邮箱地址")
//}
//// 输出:
//// 有效的邮箱地址

//if "onev@onevcat.com" =~
//    "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
//    print("有效的邮箱地址")
//}
//// 输出:
//// 有效的邮箱地址