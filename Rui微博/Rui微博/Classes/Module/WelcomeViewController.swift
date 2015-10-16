//
//  WelcomeViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/13.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    
    /// 图像底部约束
    private var iconBottomCons: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        if let urlString = UserAccout.shareUserAccount?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: urlString)!)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       iconBottomCons?.constant = -UIScreen.mainScreen().bounds.height - iconBottomCons!.constant
        // 动画
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            // 强制更新约束
            self.view.layoutIfNeeded()
            
            }) { (_) -> Void in
                
                // 发送通知，切换控制器
                NSNotificationCenter.defaultCenter().postNotificationName(SRRootControllorSwitch, object: true)
        }
    
        
    }

    private func prepareUI() {
        view.addSubview(backImage)
        view.addSubview(iconView)
        view.addSubview(label)
        //背景图片约束
        backImage.ff_Fill(view)
        
        //头像
        let icons = iconView.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSizeMake(90, 90), offset: CGPointMake(0, -160))
        iconBottomCons = iconView.ff_Constraint(icons, attribute: NSLayoutAttribute.Bottom)
        //标签
        label.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 16))
        
    }
    /// 北京图片
    private lazy var backImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ad_background"))
        return iv
    }()
    /// 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 45
        return iv
    }()
    private lazy var label:UILabel = {
        let label = UILabel()
        label.text = "欢迎归来"
        label.sizeToFit()
        return label
    }()
}
