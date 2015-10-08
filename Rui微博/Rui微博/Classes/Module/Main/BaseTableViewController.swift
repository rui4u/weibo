//
//  BaseTableViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    var index = false
    override func loadView() {
        index ? super.loadView() : setShowView()
    }
    private func setShowView() {
        view = UIView()
        view.backgroundColor = UIColor.redColor()
    }
   
}
