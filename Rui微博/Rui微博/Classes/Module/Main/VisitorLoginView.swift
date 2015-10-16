//
//  VisitorLoginView.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/9.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit 
protocol VisitorLoginViewDelegate :NSObjectProtocol {
/// 用户登录
    func visitorLoginViewWillLogin()
/// 用户注册
    func visitorLoginViewWillRegister()

}
class VisitorLoginView: UIView  {
    /// 代理属性
    weak var delegate :VisitorLoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        // 禁止用 sb / xib 使用本类
//         fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupUI()
    }
/// 点击登录监听事件
    func clickLogin() {
        delegate?.visitorLoginViewWillLogin()
        
    }
    
    
/// MARK: - 设置视图信息
    func setupViewInfo(ishome: Bool,imageName: String,title: String ){
        messageLabel.text = title
        house.image = UIImage(named: imageName)
        smallicon.hidden = !ishome
        ishome ?startAnimation() : sendSubviewToBack(maskIconView)
    }
    
    /// 开始动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20.0
        // 提示：如果界面上有动画，一定要检查退出到桌面再进入动画是否还在！
        anim.removedOnCompletion = false
        
        smallicon.layer.addAnimation(anim, forKey: nil)
    }
    func setupUI() {
        self.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        
      
        addSubview(smallicon)
        addSubview(maskIconView)
        addSubview(house)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
    /// 设置约束
        house.translatesAutoresizingMaskIntoConstraints = false
       addConstraint(NSLayoutConstraint(item: house, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: house, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))

        
        maskIconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": maskIconView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-(-50)-[regButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": maskIconView, "regButton": registerButton]))
        
        
        smallicon.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: smallicon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: house, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: smallicon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: house, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // 3> 消息文字
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: house, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: house, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        
        
        // 4> 注册按钮
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
        
        // 5> 登录按钮
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 35))
    }
    
    /// 小房子
    lazy var house: UIImageView = {
       let  image = UIImageView(image: UIImage(named:"visitordiscover_feed_image_house"))
        return image
    }()
    
    /// 遮罩
    private lazy var maskIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
        }()
    
    /// 背景
    lazy var smallicon: UIImageView = {
        let sicon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return sicon
    }()
    /// 消息文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        
        label.sizeToFit()
        
        return label
        }()
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        //btn.addTarget(self, action: "clickRegister", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
        }()
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "clickLogin", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
        }()

    
}
