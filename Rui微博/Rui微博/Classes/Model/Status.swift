//
//  Status.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            if pic_urls?.count == 0 {
            return
            }
            
            storedPictureURLs = [NSURL]()
            for dict in pic_urls! {
                if let urlString = dict["thumbnail_pic"] as? String {
                    storedPictureURLs?.append(NSURL(string: urlString)!)
                }
            }
        }
    
    }
    
    private var storedPictureURLs: [NSURL]?
    /// 用户
    var user: User?
    /// 配图的URL数组
    /// 行高
    var rowHeight: CGFloat?
    
    var pictureURLs: [NSURL]? {
//        return storedPictureURLs
        return retweeted_status == nil ? storedPictureURLs : retweeted_status?.storedPictureURLs
    }
    
    /// 用户
    /// 转发微博
    var retweeted_status: Status?
    
    class func loadStatus(since_id: Int ,max_id: Int,finished:(dataList: [Status]? , error: NSError?) ->()){

        NetworkTools.shareNetTooks.loadStatus(since_id, max_id: max_id) { (result, error) -> () in
            if error != nil {
                finished(dataList: nil, error: error)
                return
            }
            if let array = result?["statuses"] as? [[String : AnyObject]] {
                /// 遍历数组，转成模型
                var list = [Status]()
                for dict in array {
                    list.append(Status.init(dict: dict))

                }
                //数据获取后完成回调
                finished(dataList: list, error: nil)
            }else {
                finished(dataList: nil, error: nil)
            }
        }
    }
    
    init(dict : [String : AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 判断 key 是否是 user，如果是 user 单独处理
        if key == "user" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                user = User(dict: dict)
            }
            return
        }
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["created_at", "id", "text", "source", "pic_urls"]
        
        return "\(dictionaryWithValuesForKeys(keys))"
    }
}
