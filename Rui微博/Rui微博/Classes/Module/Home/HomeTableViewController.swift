//
//  HomeTableViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/8.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    var statuses: [Status]? {
        didSet{
            tableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView?.setupViewInfo(true, imageName: "visitordiscover_feed_image_house", title: "关注一些人，回这里看看有什么惊喜")
        loadData()
        prepareTableView()

    }
    
    private func prepareTableView() {
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: StatusCellIdentifier.ForwardCell.rawValue)

        tableView.estimatedRowHeight = 300
    }

    private func loadData() {
        Status.loadStatus {[weak self] (dataList, error) -> () in
            if error != nil {
                print(error)
                return
            }
            self?.statuses = dataList

        }

    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as! StatusCell
        cell.status = statuses![indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        
        if let h = status.rowHeight {
            return h
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as! StatusCell
      
        status.rowHeight =  cell.rowHeight(status)
        return status.rowHeight!
    }
}
