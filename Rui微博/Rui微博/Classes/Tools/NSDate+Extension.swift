//
//  NSDate+Extension.swift
//  时间
//
//  Created by 沙睿 on 15/10/25.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import Foundation

extension NSDate {
    class func sinaDate(string: String) -> NSDate? {
        //"Sun Oct 25 15:35:03 +0800 2015"
        let formart = NSDateFormatter()
        formart.locale = NSLocale(localeIdentifier: "ch")
        //格式不要写错。
        formart.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        return formart.dateFromString(string)
    }

    var dateDescription: String {
        
        let cal = NSCalendar.currentCalendar()
        if cal.isDateInToday(self){
            
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return String(delta / 60) + " 分钟前"
            }
            return String(delta / 3600) + " 小时前"
        }
        
        var fmtString = "HH:mm"
        
        if cal.isDateInYesterday(self) {
            
            fmtString = "昨天 " + fmtString
            
        }else {
            
            fmtString = "MM-dd " + fmtString
            
            let cons = cal.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if cons.year != 0 {
                fmtString = "yyyy " + fmtString
            }
        }
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "ch")
        df.dateFormat = fmtString
        
        return df.stringFromDate(self)
        
        
    }
}