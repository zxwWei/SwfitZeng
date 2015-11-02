//
//  XWNewFeatureVC.swift
//  XWWeibo
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class XWNewFeatureVC: UICollectionViewController {

    
    private let itemCount = 4
    
    // MARK: - 必需实现的初始化 要要有layout
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var layout = UICollectionViewFlowLayout()
    
    init(){
        super.init(collectionViewLayout:layout)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    // MARK: - 注册的时候也要改 collectionCell
        self.collectionView!.registerClass(collectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        prepareLaoyout()
        
    }

    // Mark: - 1 设置参数
    private func prepareLaoyout(){
        // 设置item的大小
        layout.itemSize = UIScreen.mainScreen().bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 分页
        collectionView?.pagingEnabled = true
        
        // 取消弹簧效果
        collectionView?.bounces = false
    
    }



    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemCount
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 将cell强制转换成自定义的cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! collectionCell
     
        // 根据indexPath.item 来改变图片
        cell.imageIndex = indexPath.item
        
        
        return cell
    }
    
    
    // MARK: - collectionView分页滚动完毕cell看不到的时候调用
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        // 正在显示的cell的indexpath
        let showIndexpath = collectionView.indexPathsForVisibleItems().first!
        
        // 正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexpath) as! collectionCell
        
        if showIndexpath.item == itemCount - 1{
        
            cell.startAnimation()
        }
        
    }

}



// MARK: - 2自定义cell

class collectionCell: UICollectionViewCell {
    
    
    // MARK: - 根据下标来切换图片  private
     var imageIndex: Int = 0 {
        didSet {
            
            backgroundImageView.image = UIImage(named:  "new_feature_\(imageIndex + 1)")
            startButton.hidden = true
            
        }
    
    }
    
    
    // MARK: - 构造方法
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    
    // MARK: - UI
    func prepareUI(){
     
        // 添加子控件
        //addSubview(backgroundImageView)
        //addSubview(startButton)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(startButton)
     

        // 添加约束
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        // VFL
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : backgroundImageView]))

        // 开始体验按钮
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
        
    
    
    }
    
    // MARK: - 按钮的动画
    func startAnimation(){
        
        startButton.hidden = false
        // 设置其缩放为0
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                
        }
    
    }
    
    
    // MARK:- 点击事件  当点击按钮时进入compass控制器
    func startButtonClick() {
        
        ((UIApplication.sharedApplication().delegate) as! AppDelegate).switchRootController(true)
        
    }
    
    
    
    // MARK: - 懒加载
    /// 背景
    private lazy var backgroundImageView = UIImageView()
    
    /// 开始体验按钮
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮背景
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 设置文字
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        // 添加点击事件
        button.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
    
}













