//
//  ComposeViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/18.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController,UITextViewDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = UIColor.whiteColor()
        setNav()
        setToolbar()
        setTextView()
    }
    
    //MARK: 监听方法
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func sendStatus() {
    
    }
    
    //MARK: 设置
    private func setTextView() {
        view.addSubview(textView)
        textView.backgroundColor = UIColor.orangeColor()
        
        textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolbar, size: nil)
//        textView.text = "分享新鲜事"
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: textView, size: nil ,offset: CGPoint(x: 5, y: 8))
        textView.delegate = self
    }
    
    
    private func setNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        
        let titleView = UIView(frame: CGRectMake(0, 0, 200, 32))
//        titleView.backgroundColor = UIColor.blackColor()
        let titleLabel = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        titleLabel.text = "发微博"
        titleLabel.sizeToFit()
         titleView.addSubview(titleLabel)
        titleLabel.ff_AlignInner(type: ff_AlignType.TopCenter, referView: titleView, size: nil)
        
        let nameLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 14)
        nameLabel.text = UserAccout.shareUserAccount?.name ?? ""
        nameLabel.sizeToFit()
        
        titleView.addSubview(nameLabel)
        nameLabel.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: titleView, size: nil)
        
      
        
        navigationItem.titleView = titleView
    }
    
    //设置toolbar
    private func setToolbar() {
        toolbar.backgroundColor = UIColor.yellowColor()
        view.addSubview(toolbar)
        toolbar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        //定义一个数组
        let itemSettings = [["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            items.append(UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: dict["action"]))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        // 删除最后一个 item
        items.removeLast()
        
        // 设置 toolBar 的 items
        toolbar.items = items
    }
    
    func inputEmoticon(){
        print(__FUNCTION__)
    }
    
    //MARK: 数据源方法
    func textViewDidChange(textView: UITextView) {
        print(textView.text)
        (textView.hasText()) ? (placeholderLabel.hidden = true) : (placeholderLabel.hidden = false)
        
    }
    
    //MARK: 懒加载
    
    private lazy var placeholderLabel = UILabel(color: UIColor.lightGrayColor(), fontSize: 18)
    
    private lazy var toolbar = UIToolbar()
    
    private lazy var textView : UITextView = {
        var t = UITextView()
        t.font = UIFont.systemFontOfSize(18)
        t.alwaysBounceVertical = true
        t.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return t
        }()
    
}