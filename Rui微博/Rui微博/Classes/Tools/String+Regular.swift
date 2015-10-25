//
//  String+Regular.swift
//  weiboFrom(正则)
//
//  Created by 沙睿 on 15/10/25.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import Foundation

extension String {
    func href() ->(link: String?, text: String?) {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        //        let pattern = "\">(.*?)</a>"
        
        //DotMatchesLineSeparators   可以让'.'换行也遍历
        let regex = try!NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        //第一匹配对象
        if let result = regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            
            print(result.numberOfRanges)
            
            let r1 = result.rangeAtIndex(1)
            let r2 = result.rangeAtIndex(2)
            
            
            return (((self as NSString).substringWithRange(r1)),((self as NSString).substringWithRange(r2)))

        }
        return (nil,nil)
    }

}