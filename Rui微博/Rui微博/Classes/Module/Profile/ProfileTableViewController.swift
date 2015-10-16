//
//  ProfileTableViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      visitorView?.setupViewInfo(false, imageName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        
    }
}
