//
//  PhotoBrowserViewController.swift
//  Rui微博
//
//  Created by 沙睿 on 15/10/19.
//  Copyright © 2015年 沙睿. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
private let SRCollectionViewCell = "SRCollectionViewCell"
class PhotoBrowserViewController: UIViewController {
    //图片URL
    var urls: [NSURL]
    //图片索引
    var selectIndex: Int
    
    init(url: [NSURL] ,index: Int){
        
        self.urls = url
        selectIndex = index
        super.init(nibName: nil, bundle: nil)
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //容易造成混乱
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
    //           let indexPath = NSIndexPath(forItem: selectIndex, inSection: 0)
//    collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
//
//    }
    
    //跳转到指定索引图片
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 跳转到用户选中的照片
        let indexPath = NSIndexPath(forItem: selectIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.mainScreen().bounds)
        var screenBounds = UIScreen.mainScreen().bounds
        screenBounds.size.width += 20
        
        view = UIView(frame: screenBounds)
       
        setupUI()
    }
    
    // MARK: 监听方法
    //关闭
    @objc private func close() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //保存图片
    @objc private func save() {
    
        let indexPath = collectionView.indexPathsForVisibleItems().last!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoBrowserCell
        
        guard let image = cell.imageView.image else {
            print("没图片")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
//        print(error)
//        print(image)
        
        let msg = (error == nil) ? "保存成功" : "保存失败"
        SVProgressHUD.showInfoWithStatus(msg)
    }
    
    
    //MARK: 设置界面
    func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
//
//        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
//
        let dict = ["VC":collectionView, "save": saveButton, "close": closeButton]
        
        collectionView.frame = view.bounds
        
        // 2> 关闭 & 保存按钮
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[save(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[close(32)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        // 提示：约束关系 =, >=, <=
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[close(100)]-(>=0)-[save(100)]-28-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        collectionView.dataSource = self
      
        prepareCollectionView()
    }
    
    /// 偏好设置
    private func prepareCollectionView() {
        
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: SRCollectionViewCell)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = UIScreen.mainScreen().bounds.size
        collectionView.pagingEnabled = true
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.itemSize = view.bounds.size
        
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    //代理方法
   

    //懒加载
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var closeButton: UIButton = UIButton(title: "关闭", fontSize: 14, textcolor: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
    private lazy var saveButton: UIButton = UIButton(title: "保存", fontSize: 14, textcolor: UIColor.whiteColor(), backColor: UIColor.darkGrayColor())
    
    /// 大菊花
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    private var photoScale: CGFloat = 1
}

extension PhotoBrowserViewController : UICollectionViewDataSource, PhotoBrowserCellDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
      //  collectionView.backgroundColor = UIColor.clearColor()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SRCollectionViewCell, forIndexPath: indexPath) as! PhotoBrowserCell
        
//        cell.backgroundColor = UIColor.randomColor()
        
        cell.imageURL = urls[indexPath.item]
        cell.photoDelegate = self
        return cell
        
    }
    
    func currentImageView() -> UIImageView {
    let cell = collectionView.cellForItemAtIndexPath(currentImageIndex()) as! PhotoBrowserCell
        
        return cell.imageView
    
    }
    
    //获取indexpath
    func currentImageIndex() ->NSIndexPath {
        
        return collectionView.indexPathsForVisibleItems().last!
    }
    
    
    ///MARK: 监听方法
    func photoBrowserCellEndZomm() {
        if photoScale < 0.8 {
           completeTransition(true)
        } else {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                //恢复形变
                self.view.transform = CGAffineTransformIdentity
                
                self.view.alpha = 1.0
            
                }, completion: { (_) -> Void in
                    self.photoScale = 1
                    self.hiddenControls(false)
            })
        }
    }
    
    
    func photoBrowserCellZomm(scale: CGFloat) {
        photoScale = scale
        print(scale)
        
        hiddenControls(scale < 1)
        
        if scale < 1 {
            self.startInteractiveTransition(self)
        }else {
            view.transform = CGAffineTransformIdentity
            view.alpha = 1.0
        }
    }
    
    /// 隐藏控件
    private func hiddenControls(hidden: Bool) {
        collectionView.backgroundColor = hidden ? UIColor.clearColor() : UIColor.blackColor()
        closeButton.hidden = hidden
        saveButton.hidden = hidden
    }
    
}

extension PhotoBrowserViewController: UIViewControllerInteractiveTransitioning {
    
    /// 开始交互专场
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 设置形变
        view.transform = CGAffineTransformMakeScale(photoScale, photoScale)
        // 设置透明度
        view.alpha = photoScale
    }
}

// MARK: UIViewControllerContextTransitioning context 提供了转场所需的所有细节！
extension PhotoBrowserViewController: UIViewControllerContextTransitioning {
    
    /// 结束专场动画
    func completeTransition(didComplete: Bool) {
        // 关闭当前的控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 容器视图
    func containerView() -> UIView? { return view.superview }
    
    func isAnimated() -> Bool { return true }
    func isInteractive() -> Bool { return true }
    func transitionWasCancelled() -> Bool { return false }
    func presentationStyle() -> UIModalPresentationStyle { return UIModalPresentationStyle.Custom }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    
    func viewControllerForKey(key: String) -> UIViewController? { return self }
    func viewForKey(key: String) -> UIView? { return view }
    func targetTransform() -> CGAffineTransform { return CGAffineTransformIdentity }
    func initialFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
    func finalFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
}
