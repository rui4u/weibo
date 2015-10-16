//
//  User.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 用户ID
    var id: Int = 0
    /// 用户姓名
    var name :String?
    /// 用户头像地址 50 x 50
    var profile_image_url: String? {
        didSet {
            imageURL = NSURL(string: profile_image_url!)
        }
    }
    /// 头像 URL
    var imageURL: NSURL?
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type:Int = -1
    /// 根据用户类型设置图标类型
    var vipImage: UIImage? {
        switch verified_type {
        case 0: return UIImage(named: "avatar_vip")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 220: return UIImage(named: "avatar_grassroot")
        default: return nil
        }
    }
    /// 会员等级1-6
    var mbrank:Int = -1
    var memberImage: UIImage?{
        if mbrank > 0 && mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        } else {
            return nil
        }
    }
    
    init(dict :[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    

}
