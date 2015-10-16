//
//  StatusNormalCell.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/16.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {

    override func setupUI() {
        super.setupUI()
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: LabelText, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
        pictureWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }

}
