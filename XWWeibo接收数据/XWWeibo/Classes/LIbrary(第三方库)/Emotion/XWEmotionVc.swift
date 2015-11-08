//
//  XWEmotionVc.swift
//  emotion
//
//  Created by apple1 on 15/11/5.
//  Copyright © 2015年 apple1. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

// 与源自于　uicollectionviewcotroller的类比较一下
// 应该是继续自　UIviewCotroller
class XWEmotionVc: UIViewController {
    
    // MARK:-  定义属性
    var textView: UITextView?
    
    // 基准tag
    let baseTag = 1000
    
    // 记录点击按钮
    var selectBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

       
        prepareUI()
    }
    
    // MARK: - 准备UI
     private func prepareUI() {
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["cv" : collectionView , "tb" : toolBar]
        
        // H
        // collectioview
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        // toolBar
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // V 垂直
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        setUpCollectionView()
        setUPToolBar()
    }
    
    // MARK: - 设置collectionView
    private func setUpCollectionView(){
        
        collectionView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        // 注册cell要用XWCollectionCell
        collectionView.registerClass(XWCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
    }
    
    // MARK:- 设置toolBar
    private func setUPToolBar() {
    
        // 定义表情包数组
        var items = [UIBarButtonItem]()
        
        // 记录索引按钮
        var index = 0
    
        for package in packages {
            
            let name = package.group_name_cn
            let button = UIButton()
            
            // 设置标题
            button.setTitle(name, forState: UIControlState.Normal)
            
            // 设置颜色
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            
            // 在穿过去之前加上baseTag
            button.tag = index + baseTag
            
            // 添加事件
            button.addTarget(self, action: "click:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // 默认选中最近表情包
            if index == 0 {
                switchToHighlight(button)
            }
            //+ baseTag
            // MARK: -  bug 没有设置frame的必需要设置这个
            button.sizeToFit()
            
            let item = UIBarButtonItem(customView: button)
            
            // 拼接进数组
            items.append(item)
            
            // 设置弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
        }
        
        // 移除最后一个弹簧
        items.removeLast()
        
        toolBar.items = items
    }
    
    // MARK: - 按钮点击事件  1.考虑名字 2.考虑私有方法是否要加@obj
    // 当tag为0的时候和tabBar的默认值0相冲突，取不到第一个按钮
     @objc private func click(btn: UIButton){

        //print("\(btn.tag)")

        // 获得对应的NSIndexpath 显示在每组的最前面 collectionView里面分为0，1，2，3组
        let path = NSIndexPath(forItem: 0, inSection: btn.tag - baseTag)
        // 点击切换到某组
        collectionView.selectItemAtIndexPath(path, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        
        // 设置选中的按钮为高亮状态
        switchToHighlight(btn)
  }
    
    // MARK: - 切换高亮状态
    func switchToHighlight(btn: UIButton){
    
        // 将之前记录的按钮的高亮状态取消
        selectBtn?.selected = false
        
        // 记录当前选中的按钮
        selectBtn = btn
        
        // 设置为高亮
        selectBtn?.selected = true
        
    }

    /// 懒加载
    //  MARK: - 不记得了，必须布局UICollectionViewFlowLayout
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: XWCollectionLayout())
    /// toolBar
    private lazy var toolBar: UIToolbar = UIToolbar()
    
    /// 表情包模型
    private lazy var packages = XWEmotionPackge.packages
    
}

// MARK: - collectionView数据源方法 对当前控制器进行延伸
extension XWEmotionVc: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        //print("\(packages.count)")
        return packages.count
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packages[section].emotions?.count ?? 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! XWCollectionCell
        
        let emotion = packages[indexPath.section].emotions?[indexPath.row]
        
        cell.emotion = emotion
        
        return  cell
    }
}

// MARK:- collectionView代理方法  XWEmotionVc延伸
extension XWEmotionVc: UICollectionViewDelegate{

    // 当点击某个cell的时候触发
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // －－取到点击的某个cell  packages 从内存中加载 一开始的时候用了方法来加载
        let emotion = XWEmotionPackge.packages[indexPath.section].emotions![indexPath.item]
        
        // 将表情传入文本
        textView!.insertEmotion(emotion)
        
        // 将表情传进去最近表情包
        // 最近表情组里面的不参与排序
        if indexPath.section != 0 {
            XWEmotionPackge.addRecentEmotion(emotion)
        }
//        // 直接刷新数据，用户体验不好
//        collectionView.reloadSections(NSIndexSet(index: 0))       
        
    }
    
    // 监听collectionView停止滚动的时候，获取到当前的cell,并设为高亮
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //print("滑动")
        // 获取正在显示的组
        let indexpath = collectionView.indexPathsForVisibleItems().first
        let section = indexpath!.section
        //print("section\(section)")

//        // 取得这个按钮，让其高亮  现在记录的tag是 section+baseTag
        let button = toolBar.viewWithTag(section + baseTag) as! UIButton
        switchToHighlight(button)
    }
    
}



/*---------------------------------------------------------------*/
// MARK: - 自定义cell
class XWCollectionCell: UICollectionViewCell {

    // MRRK: -  属性

    // 表情模型
    var emotion: XWEmotion? {
        didSet {
            // print("emoticon.png:\(emotion?.pngPath)")
            
            emotionButton.userInteractionEnabled = false
            if let pngPath = emotion?.pngPath {
            
                emotionButton.setImage(UIImage(contentsOfFile: pngPath), forState: UIControlState.Normal)
            }
            else { // // 防止cell复用
            
                emotionButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            emotionButton.setTitle(emotion?.emoji, forState: UIControlState.Normal)
            
            // emotionButton.setTitle(emotion?.emoji, forState: UIControlState.Normal)相当于
            //            if let emoji = emoticon?.emoji {
            //                emoticonButton.setTitle(emoji, forState: UIControlState.Normal)
            //            } else {
            //                emoticonButton.setTitle(nil, forState: UIControlState.Normal)
            //            }
            
            //  当模型是删除模型时
            if emotion!.removeEmotion {
            
            emotionButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }
        }
    }
    
    
    // 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    func prepareUI() {
        // 添加子控件
        contentView.addSubview(emotionButton)
        
        emotionButton.frame = CGRectInset(bounds, 4, 4)
        emotionButton.titleLabel?.font = UIFont.systemFontOfSize(32)
//        emotionButton.backgroundColor = UIColor.orangeColor()
    }
    
    // 设置emotionButton
    private lazy var emotionButton: UIButton = UIButton()
}


// MARK: - 布局layout
class XWCollectionLayout: UICollectionViewFlowLayout {

    // 重写preparelayout
    override func prepareLayout() {
        
        super.prepareLayout()
        
        let width = (collectionView?.frame.size.width)! / 7
        let height = (collectionView?.frame.height)! / 3
        
        // 设定每个cell的size
        itemSize = CGSizeMake(width, height)
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 取消弹簧效果
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.alwaysBounceHorizontal = false
        
        // 分页效果
        collectionView?.pagingEnabled = true
    }
}




