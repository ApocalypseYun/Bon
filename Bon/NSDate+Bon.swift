//
//  NSDate+Bon.swift
//  Bon
//
//  Created by Chris on 16/4/22.
//  Copyright © 2016年 Chris. All rights reserved.
//

import Foundation

extension NSDate {
    
//    // you can create a read-only computed property to return just the nanoseconds as Int
//    var nanosecond: Int { return NSCalendar.currentCalendar().component(.CalendarUnitNanosecond,  fromDate: self)   }
    
    // or an extension function to format your date
    func formattedWith(format: String) -> String {
        let formatter = NSDateFormatter()
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        formatter.timeZone = NSTimeZone.localTimeZone()        // or as local time
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    func timeFromSeconds(seconds: Int) -> String {
        let date = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(seconds)) // it means give me the time that happens after January,1st, 2001, 12:00 am by zero seconds
        //print(date)
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        formatter.timeZone = NSTimeZone(name: "UTC")
        let time = formatter.stringFromDate(date)
        //print(text) //2001-01-01 00:00:00
        return time
        
    }
}
