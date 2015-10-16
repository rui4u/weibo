//
//  UserAccout.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/12.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class UserAccout: NSObject ,NSCoding{
    /// 用户是否登录标记
    class var userLogon: Bool {
        return shareUserAccount != nil
    }
    
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    /// access_token的生命周期，单位是秒数 - 准确的数据类型是`数值`
    var expires_in: NSTimeInterval = 0 {
        didSet {
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: NSDate?
    /// 当前授权用户的UID
    var uid: String?
    
    /// 友好显示名称
    var name: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        UserAccout.userAccount = self
    }
    
    /// 利用运行时机制，排除key缺失情况
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    func loadUserInfo(finished: (error: NSError?)->()) {
        NetworkTools.shareNetTooks.loadUserInfo(uid!) { (result, error) -> () in
            if error != nil {
                // 提示：error一定要传递！
                finished(error: error)
                return
            }
            // 设置用户信息
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 保存用户信息
            self.saveAccount()
            
            // 完成回调
            finished(error: nil)
        }
    
    }
    /// 保存文件路径
    static private let accountPath = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true).last!.stringByAppendingString("/account.plist")
    
    func saveAccount(){
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccout.accountPath)
    }
 /// 静态用户属性
    private static var userAccount: UserAccout?
    class var shareUserAccount : UserAccout? {
        if userAccount == nil {
            userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccout
        }
        if let date = userAccount?.expiresDate where date.compare(NSDate()) == NSComparisonResult.OrderedAscending{
            //账号已过期,,清空账号信息
            userAccount = nil

        }
        return userAccount
    }
    // MARK: - NSCoding
    /// `归`档 -> 保存，将自定义对象转换成二进制数据保存到磁盘
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    /// `解`档 -> 恢复 将二进制数据从磁盘恢复成自定义对象
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }

}
