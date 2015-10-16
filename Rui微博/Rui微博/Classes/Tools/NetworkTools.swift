//
//  NetworkTools.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/10.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import AFNetworking
/// 标记错误标记
private let SRErrorDomainName = "com.itheima.error.network"
private enum SRNetworkError :Int {
    case emptyDataError = -1
    case emptyTokenError = -2
    private var errorDescrption: String {
        switch self {
        case .emptyDataError :return "空数据"
        case.emptyTokenError :return "空Token"
        }
    }
    private func error() ->NSError {
        return NSError(domain: SRErrorDomainName, code: rawValue, userInfo: [SRErrorDomainName : errorDescrption])
    }
}
private enum SRNetworkMethod : String {
    case POST = "POST"
    case GET = "GET"
}


class NetworkTools: AFHTTPSessionManager {
    
    
    // MARK: - 应用程序信息
    private let clientId = "2962619715"
    private let appSecret = "cfcff4fabc3561a03bbe201110a8a2a2"
    /// 回调地址
    let redirectUri = "http://www.baidu.com"
    

    static let shareNetTooks :NetworkTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let tools = NetworkTools(baseURL: baseURL)
         tools.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        return tools
        
    }()
    /// oAuthUrl 地址
    
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)"
        return NSURL(string: urlString)!
    }
    
    
    /// 自定义回调类型
    typealias SRNetFinishedCallBack = (result: [String: AnyObject]?, error: NSError?)->()
    /// 加载微博数据
    func loadStatus(finished:SRNetFinishedCallBack) {
        guard let params = tokenDict(finished) else{
             return
        }
        let urlString = "2/statuses/home_timeline.json"
        request(SRNetworkMethod.GET, urlString: urlString, params: params, finished: finished)
    }
    
    
    /// 加载用户数据
    func loadUserInfo(uid: String, finished: SRNetFinishedCallBack) {
        guard var params = tokenDict(finished) else {
            return
        }
        let urlString = "2/users/show.json"
        params["uid"] = uid
        
        request(SRNetworkMethod.GET, urlString: urlString, params: params, finished: finished)
    }
    
    /// 检查并声明token字典
    private func tokenDict(finished:SRNetFinishedCallBack) ->[String :AnyObject]?{
        if UserAccout.shareUserAccount?.access_token == nil {
            let error = SRNetworkError.emptyTokenError.error()
            print(error)
            finished(result: nil, error: error)
        }
        return ["access_token" : UserAccout.shareUserAccount!.access_token!]
    }
    
    /// 加载TOKEN
    func loadAccessToken(code: String,finished:SRNetFinishedCallBack) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":clientId,
            "client_secret": appSecret,
            "grant_type":"authorization_code",
            "code": code,
            "redirect_uri":redirectUri
        ]
        request(SRNetworkMethod.POST, urlString: urlString, params: params, finished: finished)
    }
    
    /// 封装AFN方法
    ///
    /// - parameter method:    自定义网络类型
    /// - parameter urlString: URL字符串
    /// - parameter params:    字典参数
    /// - parameter finished:  完成回调
    private func request (method: SRNetworkMethod ,urlString: String, params:[String: AnyObject],finished:SRNetFinishedCallBack) {
        
    
         /// 自定义成功回调
         let successedCallBack :(NSURLSessionDataTask!,AnyObject!) ->Void = {(_,JSON) ->Void in
            
            if let result = JSON as? [String :AnyObject] {
                finished(result: result, error: nil)
            } else {
                print("没有数据 \(method) Request \(urlString)")
                
                finished(result: nil, error: SRNetworkError.emptyDataError.error())
            }
        }
       /// 定义失败回调
       let failedCallBack: (NSURLSessionDataTask!, NSError!) -> Void = { (_, error) -> Void in
            print(error)
            
            finished(result: nil, error: error)
        }
        /// 选择回调
        switch method {
        case .GET : GET(urlString, parameters: params, success: successedCallBack, failure: failedCallBack)
        case .POST :POST(urlString, parameters: params, success: successedCallBack, failure: failedCallBack)
        }
        
    }
    
}
