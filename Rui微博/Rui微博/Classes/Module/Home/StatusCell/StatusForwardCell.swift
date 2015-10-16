//
//  StatusForwardCell.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class StatusForwardCell: StatusCell {

    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            
            forwardLabel.text = "@" + name + ":" + text
        }
    }
    /// 设置界面
    override func setupUI() {
        super.setupUI()
        // 1. 添加控件
        contentView.insertSubview(backButton, belowSubview:pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: backButton)
        
        // 2. 设置布局
        // 1> 背景按钮
        backButton.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: LabelText, size: nil, offset: CGPoint(x: -8, y: 8))
        backButton.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        // 2> 转发文本
        forwardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backButton, size: nil, offset: CGPoint(x: 8, y: 8))
        
        // 3> 配图视图
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forwardLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    private lazy var forwardLabel: UILabel = {
        let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 14)
        
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * 8
        
        return label
        }()
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        
        btn.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        
        return btn
        }()


}
