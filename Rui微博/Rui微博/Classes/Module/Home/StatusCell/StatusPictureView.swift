//
//  StatusPictureView.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit

private let statusPictureViewCellID = "statusPictureViewCellID"

class StatusPictureView: UICollectionView {
    
    var status :Status? {
        didSet {
            sizeToFit()
            reloadData()
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcViewSize()
    }

    /// 计算view的大小
    func calcViewSize() -> CGSize {
        let itemSize = CGSizeMake(90, 90)
        let margin: CGFloat = 10
        let rowCount = 3
        let itemCount = status?.pictureURLs?.count ?? 0
          pictureLayout.itemSize = itemSize
        if itemCount == 0 {
            return CGSizeZero
        }
        if itemCount == 1 {
            let size = CGSizeMake(150, 120)
            pictureLayout.itemSize = size
            return size
        }
        if itemCount == 4 {
            let sizeW = itemSize.width * 2 + margin
            return CGSizeMake(sizeW, sizeW)
        }
        
        let row = (itemCount - 1) / rowCount + 1
        let w = itemSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itemSize.height * CGFloat(row) + margin * CGFloat(row - 1)
        
        return CGSize(width: w, height: h)
    }
    
    let pictureLayout = UICollectionViewFlowLayout()
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        
        backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        /// 注册cell
        registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureViewCellID)
        self.dataSource = self
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusPictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureViewCellID, forIndexPath: indexPath) as! StatusPictureViewCell
        
        cell.imageURL = status!.pictureURLs![indexPath.item]
        
        return cell
    }
}

class StatusPictureViewCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        didSet {
            iconView.sd_setImageWithURL(imageURL!)
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        
        iconView.ff_Fill(contentView)
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
}

