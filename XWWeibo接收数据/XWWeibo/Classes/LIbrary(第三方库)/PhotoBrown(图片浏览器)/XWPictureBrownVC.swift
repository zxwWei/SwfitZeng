//
//  XWPictureBrownVC.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/8.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SVProgressHUD

let XWPhotoSelectorMincItemSpacing: CGFloat = 10
let reuserIndentier = "reuserIndentier"
class XWPictureBrownVC: UIViewController {
    
    
    //MARK: - 属性存在的时候 初始化要一起初始化
    
    // 设置参数
    /// urls数组
    let urls: [NSURL]?
    
    /// 被点击的下标
    let selectIndex: Int?
    
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()

    /// 构造函数
    init(urls: [NSURL], selectIndex: Int){
        
        self.urls = urls
        self.selectIndex = selectIndex
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.backgroundColor = UIColor.redColor()
        // 准备UI
        prepareUI()
    }
    
    // 当点击　cell时 自动到某张图片 当视窗将要出现时
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let path = NSIndexPath(forItem: selectIndex!, inSection: 0)
        collectionView.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
    }
    
    //MARK:- 准备UI
    private func prepareUI(){
        
        // 添加子控制器
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        view.addSubview(pageLabel)
        
        // 按钮添加点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束
        let views = [
                "collectionView":collectionView,
                "closeButton":closeButton,
                "saveButton":saveButton,
                "pageLabel":pageLabel
        ]
        
        // 用frame设置它的frame  容器增大到可以容纳有间距  没间距会连在一起
        collectionView.frame = CGRectMake(0, 0, UIScreen.width() + XWPhotoSelectorMincItemSpacing, UIScreen.height())
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
//        // MARK: bug -绑定约束的时候一定要注意
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // 显示页数的页码
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        
        // 关闭，保存按钮的设置
      
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[closeButton(75)]-(>=0)-[saveButton(75)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        prepareCollectionView()
    }
    
    // 准备collectionView
    private func prepareCollectionView(){
        
        // 注册
        collectionView.registerClass(XWPhotoSelectorCell.self, forCellWithReuseIdentifier: reuserIndentier)
        
        layout.itemSize = view.bounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 组间距  要重设　collectionview的frame
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, XWPhotoSelectorMincItemSpacing)
        
        // 间距设定为0
        layout.minimumInteritemSpacing = XWPhotoSelectorMincItemSpacing
        layout.minimumLineSpacing = XWPhotoSelectorMincItemSpacing
//        
//      layout.minimumInteritemSpacing = 0
//      layout.minimumLineSpacing = 0
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    //MARK: -按钮点击事件 @objc
    @objc private func close(){
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func save(){
        
        // 取得正在显示的图片
        let indexpath = collectionView.indexPathsForVisibleItems().first!
        let cell = collectionView.cellForItemAtIndexPath(indexpath) as! XWPhotoSelectorCell
        
        let image = cell.imageView.image
     
        //保存图片
        /*
        参数:
        image: 要保存的图片
        completionTarget: 完成后的回调对象
        completionSelector: 完成后的回调方法
        */
          UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
    }
    
    //实现 保存图片 的 回调方法
    // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    /// 图片保存后的回调方法
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            print("error: \(error)")
            SVProgressHUD.showErrorWithStatus("保存图片失败", maskType: SVProgressHUDMaskType.Black)
            
            return
        }
        
        SVProgressHUD.showSuccessWithStatus("保存图片成功", maskType: SVProgressHUDMaskType.Black)
    }
    
    
    
    //MARK: -懒加载
    
    /// collectionView
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// 关闭
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 保存
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 页码的label
    private lazy var pageLabel = UILabel(fonsize: 15, textColor: UIColor.whiteColor())
    
}

// MARK: - 延伸 代理数据源
extension XWPictureBrownVC: UICollectionViewDataSource,UICollectionViewDelegate{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 取得url
        let url = urls![indexPath.item]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuserIndentier, forIndexPath: indexPath) as! XWPhotoSelectorCell
        
        cell.backgroundColor = UIColor.randomColor()
        
        cell.url = url
        
        pageLabel.text = "\(indexPath.item + 1) / \(urls!.count) "
        
        return cell
    }
}

// MARK: - 转场动画的代理延伸 
//extension XWPictureBrownVC: UIViewControllerTransitioningDelegate{
//    
//    // 返回控制modal对象的方法
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return XWPhotoBrownModalAnimation()
//    }
//    
//    // 返回控制dimiss对象的方法
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return XWPhotoDismissAnimation()
//    }
//
//}












