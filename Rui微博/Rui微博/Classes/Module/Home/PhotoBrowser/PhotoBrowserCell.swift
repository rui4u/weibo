//
//  PhotoBrowserCell.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/19.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SDWebImage
class PhotoBrowserCell: UICollectionViewCell ,UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet{
//            print(imageURL)
            
             indicator.startAnimating()
            //清空缓存
            
           
            
            resetImageInset()
            
            imageView.image = nil
           
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0)), dispatch_get_main_queue(), {

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.imageView.sd_setImageWithURL(self.imageURL) { (image, _, _, _) in
                    
                    self.indicator.stopAnimating()
                    
                    if image == nil {
                        print("网络超时")
                        return
                    }
                    //等到完成后调用setupImagePostion
                    
                    self.setupImagePostion()
                }
 
            })
//                  })
          
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetImageInset() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
    }
    
    private func setupImagePostion() {
        let s = setImageScale(imageView.image!)

//        print("---\(s.height)")
        if s.height < scrollView.bounds.height {
            
            let y = (scrollView.bounds.height - s.height) * 0.5
            imageView.frame = CGRect(origin: CGPointZero, size: s)
            
//            print(y)
            
            // 设置间距，能够保证缩放完成后，同样能够显示完整画面
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        } else if s.height >= scrollView.bounds.height{
            // 长图
            imageView.frame = CGRect(origin: CGPointZero, size: s)
            // contentSize
            scrollView.contentSize = s
        }
        
    }
    
    

    
    private func setImageScale(image : UIImage) -> CGSize{
        
        let scale =  image.size.height / image.size.width
        
        let height =  scale * UIScreen.mainScreen().bounds.width
        
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: height)
        
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(indicator)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[vc]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["vc" : scrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[vc]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["vc" : scrollView]))
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
    //MARK : dalegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        // 通过 transform 改变view的缩放，bound本身没有变化，frame会变化
        var offsetX = (scrollView.bounds.width - view!.frame.width ) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        var offsetY = (scrollView.bounds.height - view!.frame.height ) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
        
    }
    
    
    //MARK:lazy
    lazy var imageView = UIImageView()
    private lazy var scrollView = UIScrollView()
    /// 大菊花
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}
