//
//  NSDate+Bon.swift
//  Bon
//
//  Created by Chris on 16/4/22.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation

extension Date {
    
//    // you can create a read-only computed property to return just the nanoseconds as Int
//    var nanosecond: Int { return NSCalendar.currentCalendar().component(.CalendarUnitNanosecond,  fromDate: self)   }
    
    // or an extension function to format your date
    func formattedWith(_ format: String) -> String {
        let formatter = DateFormatter()
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        formatter.timeZone = TimeZone.autoupdatingCurrent        // or as local time
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeFromSeconds(_ seconds: Int) -> String {
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(seconds)) // it means give me the time that happens after January,1st, 2001, 12:00 am by zero seconds
        //print(date)
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone(identifier: "UTC")
        let time = formatter.string(from: date)
        //print(text) //2001-01-01 00:00:00
        return time
        
    }
}
