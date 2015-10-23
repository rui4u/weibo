//
//  SRRefreshControllor.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/16.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
    
    /// 下拉刷新的偏移量，超出之后，翻转动画
    private let kRefreshPullOffset: CGFloat = -60
    
    /// 下拉刷新控件，集成在 tableView controller
    class SRRefreshControl: UIRefreshControl {
        
        override init() {
            super.init()
            setupUI()
        }
        
        override func endRefreshing() {
            super.endRefreshing()
            refreshView.stopLoading()
        }
        
        //监听
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//            print(frame.origin.y)
            
            if refreshing {
                refreshView.startLoading()
            }
            if frame.origin.y < kRefreshPullOffset && !refreshView.rotateFlag {
                refreshView.rotateFlag = true
            }else if frame.origin.y > kRefreshPullOffset && refreshView.rotateFlag{
                refreshView.rotateFlag = false
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //设置
        func setupUI(){
            //添加监听KVO
            self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            
            //清除自带滚轮颜色
            tintColor = UIColor.clearColor()
            addSubview(refreshView)
            
            //调整位置。自动调整大小
            refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
            
        }
        /// lazy load
        private lazy var refreshView :SRRefreshView = SRRefreshView.refreshView()
        
        
}    /// 下拉刷新视图 - `负责显示和动画`
    class SRRefreshView: UIView {
        var rotateFlag = false {
            didSet {
                rotateTipIcon()
            }
        }
        
        @IBOutlet weak var loadingIcon: UIImageView!
        @IBOutlet weak var tipView: UIView!
        @IBOutlet weak var tipIcon: UIImageView!
        
        
        class func refreshView() -> SRRefreshView{
            return NSBundle.mainBundle().loadNibNamed("SRRefreshView", owner: nil, options: nil).last as! SRRefreshView
        }
        func rotateTipIcon() {
            //iOS 中旋转是靠近原则。所以用一下方案解决
            let angle = rotateFlag ? CGFloat(M_PI - 0.01) : CGFloat(M_PI + 0.01)
            UIView.animateWithDuration(0.25) { () -> Void in
                self.tipIcon.transform = CGAffineTransformRotate(self.tipIcon.transform, angle)
            }
        }
         /// 开始旋转
        private func startLoading() {
            self.tipView.hidden = true
            //如果动画存在直接返回
            
            if loadingIcon.layer.animationForKey("loadingAnim") != nil {
                return
            }
          
            let anim = CABasicAnimation(keyPath: "transform.rotation")
            anim.toValue = 2 * M_PI
            anim.repeatCount = MAXFLOAT
            anim.duration = 2.0
            
            loadingIcon.layer.addAnimation(anim, forKey: "loadingAnim")
        }
        
        //移除动画
        private func stopLoading() {
            tipView.hidden = false
            loadingIcon.layer.removeAllAnimations()
        
        }
    }

