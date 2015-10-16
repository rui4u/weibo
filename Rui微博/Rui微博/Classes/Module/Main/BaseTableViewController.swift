//
//  BaseTableViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorLoginViewDelegate{
    var userLogon = UserAccout.userLogon
    var visitorView: VisitorLoginView?
    override func loadView() {
        userLogon ? super.loadView() : setShowView()
    }
    private func setShowView() {
        visitorView = VisitorLoginView()
        visitorView?.delegate = self
        view = visitorView
    }
    func visitorLoginViewWillLogin() {
    let nav = UINavigationController(rootViewController: OAuthViewController())
    presentViewController(nav, animated: true, completion: nil)
    }
    func visitorLoginViewWillRegister() {
        
    }
}
