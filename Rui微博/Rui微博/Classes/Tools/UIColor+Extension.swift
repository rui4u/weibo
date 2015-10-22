//
//  UIColor+Extension.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/19.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomColor() -> UIColor{
        return UIColor(red: randomNum(), green: randomNum(), blue: randomNum(), alpha: 1.0)
    
    }
    class func randomNum() -> CGFloat {
        return CGFloat(arc4random_uniform(256))/255
    }

}
