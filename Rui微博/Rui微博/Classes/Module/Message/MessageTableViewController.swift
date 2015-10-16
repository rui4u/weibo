//
//  MessageTableViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
visitorView?.setupViewInfo(false, imageName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }
}
