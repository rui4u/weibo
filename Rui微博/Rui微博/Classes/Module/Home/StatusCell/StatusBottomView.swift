//
//  StatusBottomView.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SDWebImage
class StatusBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.lightGrayColor()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 设置控件
    private func setupUI() {
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        /// 设置水平布局
        ff_HorizontalTile([forwardButton, commentButton, likeButton], insets: UIEdgeInsetsZero)
        
    }
    
    
    // MARK: - 懒加载控件
    private lazy var forwardButton: UIButton = UIButton(title: "转发", imageName: "timeline_icon_retweet")
    private lazy var commentButton: UIButton = UIButton(title: "评论", imageName: "timeline_icon_comment")
    private lazy var likeButton: UIButton = UIButton(title: "赞", imageName: "timeline_icon_unlike")
    
}
