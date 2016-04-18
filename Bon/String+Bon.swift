//
//  String+Bon.swift
//  Bon
//
//  Created by Chris on 16/4/18.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation

extension String {
    var MD5: String {
        let md5 = self.md5()
        let start =  md5.startIndex.advancedBy(8)
        let end = md5.endIndex.advancedBy(-8)
        let range = Range<String.Index>(start..<end)
        
        return md5.substringWithRange(range)
    }
}