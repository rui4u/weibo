//
//  OAuthViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/12.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController,UIWebViewDelegate {
    private lazy var webView = UIWebView()
    override func loadView() {
        view = webView
        webView.delegate = self
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action:"close")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 请求URL
 
        webView.loadRequest(NSURLRequest(URL: NetworkTools.shareNetTooks.oauthUrl()))
    }
    
    func close(){
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// MARK - 代理方法
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!.absoluteString
//        print(url)
//        print(url.hasPrefix(NetworkTools.shareNetTooks.redirectUri))
        /// 判断是否包含回调地址
        if !url.hasPrefix(NetworkTools.shareNetTooks.redirectUri) {
            return true
        }
        //query 获取回调中的token
        if let query = request.URL?.query where query.hasPrefix("code=") {
            let code = query.substringFromIndex("code=".endIndex)
//            print("code = " + code)
            //换取TOKEN
            loadAccessToken(code)
        }else {
            close()
        }
        
        return true
    }
    
    private func loadAccessToken(code: String) {
        NetworkTools.shareNetTooks.loadAccessToken(code) { (result, error) -> () in
            if result == nil || error != nil {
                
                 self.netError()
                return
            }
            //获取账户信息，并在模型中保存
            UserAccout(dict: result!).loadUserInfo({ (error) -> () in
                if error != nil {
                    self.netError()
                    return
                }
                /// 发送通知
            NSNotificationCenter.defaultCenter().postNotificationName(SRRootControllorSwitch, object: false)
            self.close()
            })
        }
    }
    /// 网络出错处理
    private func netError() {
        SVProgressHUD.showInfoWithStatus("您的网络不给力")
        
        // 延时一段时间再关闭
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
        dispatch_after(when, dispatch_get_main_queue()) {
            self.close()
        }
    }

}
