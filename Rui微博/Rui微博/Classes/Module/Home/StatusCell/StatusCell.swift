//
//  StatusCell.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

enum StatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    static func cellId(status: Status) ->String {
        
     return (status.retweeted_status == nil) ? StatusCellIdentifier.NormalCell.rawValue :StatusCellIdentifier.ForwardCell.rawValue
    }
}


class StatusCell: UITableViewCell {
    
    var status: Status? {
        didSet {
            topView.status = status
            LabelText.text = status?.text
            pictureView.status = status
            
            pictureWidthCons?.constant = pictureView.bounds.size.width
            pictureHeightCons?.constant = pictureView.bounds.size.height
            
        }
    
    }
    
    var pictureWidthCons: NSLayoutConstraint?
    var pictureHeightCons: NSLayoutConstraint?
    var pictureTopCons: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        
        
        
        contentView.addSubview(topView)
        contentView.addSubview(LabelText)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        //顶部视图
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        
        //文本视图
        LabelText.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size:nil, offset: CGPointMake(8, 8))
        //文本宽度
        contentView.addConstraint( NSLayoutConstraint(item: LabelText, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -16))
        
        // 3> 配图视图
//        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: LabelText, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
//        
//        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        //底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPointMake(-8, 8))
    }
    
    
    
    
    
    
    /// 获取行高
    func rowHeight(status: Status) -> CGFloat {
        // 设置属性
        self.status = status
        
        layoutIfNeeded()
        // 返回底部视图的最大高度
        return CGRectGetMaxY(bottomView.frame)
    }
    
    
    
    
    //MARK: Lazy
 /// 顶部视图
     lazy var topView: StatusTopView = StatusTopView()
     lazy var LabelText: UILabel = {
        var lb = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
        lb.numberOfLines = 0
        return lb
    }()
    
     lazy var pictureView: StatusPictureView = StatusPictureView()
 /// 底部视图
     lazy var bottomView: StatusBottomView = StatusBottomView()

}
