//
//  StatusPictureView.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/15.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SDWebImage

/// 选中照片通知
let SRStatusCellSelectPictureNotification = "SRStatusCellSelectPictureNotification"
/// URL 的 KEY
let SRStatusCellSelectPictureURLKey = "SRStatusCellSelectPictureURLKey"
/// IndexPath 的 KEY
let SRStatusCellSelectPictureIndexKey = "SRStatusCellSelectPictureIndexKey"

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
            
            let key = status!.pictureURLs![0].absoluteString
            //利用SDWebImage 进行缓存

            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            var size = CGSizeMake(150, 120)
            
            if image != nil {
                size = image.size
            }
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.width > UIScreen.mainScreen().bounds.width ? 150 : size.width
            
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
        self.delegate = self
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(SRStatusCellSelectPictureNotification,
            object: self,
            userInfo: [SRStatusCellSelectPictureURLKey: status!.largePictureURLs!,
               SRStatusCellSelectPictureIndexKey: indexPath])
        
        //获取当前cell
//        let v = UIView()
//        v.frame = cellFullScreenFrame(indexPath)
//        v.backgroundColor = UIColor.redColor()
//        UIApplication.sharedApplication().keyWindow?.addSubview(v)
        
        // 监听方法，执行完成之后，才会被调用
//        print("come here")
        
        
    }
    
    func cellScreenFrame(indexPath: NSIndexPath) -> CGRect {
        let cell = self.cellForItemAtIndexPath(indexPath)!
        //cell相对屏幕的frame
        return convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
    }
    
    func cellFullScreenFrame(indexPath: NSIndexPath) -> CGRect {
    
        let key = status?.pictureURLs![indexPath.item].absoluteString
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
        let scale = image.size.height / image.size.width
        let height = UIScreen.mainScreen().bounds.width * scale
        
        var y :CGFloat = 0
        if height < UIScreen.mainScreen().bounds.height {
            y = (UIScreen.mainScreen().bounds.height - height) * 0.5
        }
        return CGRect(x: 0, y: y, width: UIScreen.mainScreen().bounds.width, height: height)
    }
    
    
    
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
            // 根据 URL 的扩展名判断是否是 gif / GIF
            // 提示用户，图大，耗流量，好玩！
            gifImageView.hidden = ((imageURL!.absoluteString as NSString).pathExtension.lowercaseString != "gif")
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
        iconView.addSubview(gifImageView)
        iconView.ff_Fill(contentView)
        
        gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: nil)
    }
    
    // MARK: 懒加载控件
    private lazy var iconView: UIImageView = {
        var iv = UIImageView()
        //设置图片填充模式
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        
        iv.clipsToBounds = true
        return iv
        }()
    
    private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
}

