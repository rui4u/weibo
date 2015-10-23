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

        if !UserAccout.userLogon {
        visitorView?.setupViewInfo(true, imageName: "visitordiscover_feed_image_house", title: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        //注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectPicture:", name: SRStatusCellSelectPictureNotification, object: nil)
        
        
        prepareTableView()
        loadData()

    }
    //监听方法
    @objc private func selectPicture(n: NSNotification){
        
        guard let urls = n.userInfo![SRStatusCellSelectPictureURLKey] as? [NSURL] else{
            print("urls为空")
            return
        }
        guard let index = n.userInfo![SRStatusCellSelectPictureIndexKey] as? NSIndexPath else{
            print("index为空")
            return
        }
        
        guard let picView = n.object as? StatusPictureView else {
            print("图片不存在")
            return
        }
        //记录属性
        pictureView = picView
        presentViewIndexPath = index
        //设置专场动画View
        presentIconView.sd_setImageWithURL(urls[index.item])
        
        
        
        let vc = PhotoBrowserViewController(url: urls, index: index.item)
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle =  UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
        
      
    }
    
    private func prepareTableView() {
        
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: StatusCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardCell.self, forCellReuseIdentifier: StatusCellIdentifier.ForwardCell.rawValue)
        //预估行高
        tableView.estimatedRowHeight = 300
        //取消cell的线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
     
        
        //自定义刷新
        refreshControl = SRRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
    }

    /// 上拉刷新的标记
    private var pullupRefreshFlag = false
    
     func loadData() {
        //开始动画
        self.refreshControl?.beginRefreshing()
        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        //判断是否为上拉刷新
        if pullupRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        /// 读取数据
        Status.loadStatus(since_id, max_id: max_id) { (dataList, error) -> () in
            
            // 关闭刷新控件，结束刷新动画
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                print(error)
                return
            }
            let count = dataList?.count ?? 0
            
            if since_id > 0 {
                self.showPulldownTip(count)
            }
            
            if count == 0 {
                
                return
            }
            
            if since_id > 0 {       // 做下拉刷新，应该将结果集合放在之前数组的前面
                self.statuses = dataList! + self.statuses!
            } else if max_id > 0 {  // 做上拉刷新，应该讲结果集合放在数组的后面
                self.statuses! += dataList!
                
                // 复位上拉刷新标记，保证下一次仍然能够上拉
                self.pullupRefreshFlag = false
            } else {
                self.statuses = dataList
            }

        }

    }
    
    
    
    /// 显示下拉刷新的数据条数
    private func showPulldownTip(count: Int) {
        
        tipLabel.text = (count == 0) ? "暂时没有新的微博" : "刷新到\(count)条微博"
        // 获取初始位置
        
        let rect = tipLabel.frame
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            //自动翻转动画
             UIView.setAnimationRepeatAutoreverses(true)
            
            self.tipLabel.frame = CGRectOffset(rect, 0, 3*rect.height)
            
            }) { (_) -> Void in
               self.tipLabel.frame = rect
        }
        
        
    }
    
    //数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as? StatusCell
      
        
        //判断是否需要下拉刷新
        if indexPath.row == statuses!.count - 1 {
            pullupRefreshFlag = true
            loadData()
        }
        
        cell!.status = statuses![indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuses![indexPath.row]
        
        if let h = status.rowHeight {
            return h
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier.cellId(status)) as?StatusCell
      
        status.rowHeight =  cell!.rowHeight(status)
        return status.rowHeight!

    }
    
    // MARK: - 懒加载
    
    private lazy var tipLabel: UILabel = {
        let h :CGFloat = 44
        let label = UILabel(frame: CGRectMake(0, -2 * h, self.view.bounds.width, h))
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.orangeColor()
        label.textAlignment = NSTextAlignment.Center
        
        //insertSubview 是加到内部  而addSubview 是加到最上方
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        return label
    }()
    private var isPresented = false
    //专场过程中的图像视图
    private lazy var presentIconView: UIImageView = {
        let iv =  UIImageView()
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var pictureView: StatusPictureView?
    private var presentViewIndexPath : NSIndexPath?
    
}

extension HomeTableViewController : UIViewControllerTransitioningDelegate {
    
    //返回提供自定义转场动画的对象，该对象必须遵守UIViewControllerAnimatedTransitioning协议
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    //提供一个解除转场动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
}

extension HomeTableViewController: UIViewControllerAnimatedTransitioning {
    
    //必须实现的两个方法
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 2.0
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
//        let fromVC = transitionContext.viewForKey(UITransitionContextFromViewKey)
//        let toVC = transitionContext.viewForKey(UITransitionContextToViewKey)
        
//        print(fromVC)
//        print(toVC)
        
        if isPresented {
            
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            //将动画图像添加到目标视图中
            transitionContext.containerView()?.addSubview(presentIconView)
            //设置图像视图起始位置
            
            let fromRect = pictureView?.cellScreenFrame(presentViewIndexPath!)
            let toRect = pictureView?.cellFullScreenFrame(presentViewIndexPath!)
            
            presentIconView.frame = fromRect!

            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in

                self.presentIconView.frame = toRect!
                }, completion: { (_) -> Void in
              
                    self.presentIconView.removeFromSuperview()
                    toView.backgroundColor = UIColor.clearColor()
                    transitionContext.containerView()?.addSubview(toView)
                    //动画执行后，一定要执行，否则系统会一直等待。无法进行后续的交互
                    transitionContext.completeTransition(true)
                    
            })
            
        } else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                fromView.alpha = 0.0
                
                }, completion: { (_) -> Void in
                    
                  fromView.removeFromSuperview()
                    
                    // 解除转场时，会把 容器视图以及内部的内容一起销毁
                    transitionContext.completeTransition(true)
                    
            })
        }
        
        
    }
}
