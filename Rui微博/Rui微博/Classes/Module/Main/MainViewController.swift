//
//  MainViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.addSubview(setButton)
        setButton.frame = CGRectMake(tabBar.bounds.width/5*2, 0, tabBar.bounds.width/5,tabBar.bounds.height)
    }

    private lazy var setButton: UIButton = {
        var btn = UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Selected)
        
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Selected)
        btn.addTarget(self, action:"clickButton", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
///  '+'点击方法，不能为私有，否则调用不到
     func clickButton() {
        print(__FUNCTION__)
    }
    
    private func setup() {
        
        setItem(HomeTableViewController(), title: "首页", image: "tabbar_home")
        setItem(MessageTableViewController(), title: "消息", image:"tabbar_message_center")
        
        setItem(UIViewController(), title:"", image:nil)
        
        setItem(DiscoverTableViewController(), title: "发现", image:"tabbar_discover")
        setItem(ProfileTableViewController(), title: "我", image:"tabbar_profile")
    
    }
    private func setItem(vc:UIViewController,title:String,image:String?) {
        let na = UINavigationController()
        tabBar.tintColor = UIColor.orangeColor()
        vc.title = title
        if image != nil {
        vc.tabBarItem.image = UIImage(named:image!)
        }
        na.addChildViewController(vc)
        addChildViewController(na)
        
    }

}
