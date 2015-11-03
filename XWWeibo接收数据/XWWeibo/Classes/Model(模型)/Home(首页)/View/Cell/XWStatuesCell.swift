//
//  XWStatuesCell.swift
//  XWWeibo
//
//  Created by apple1 on 15/10/31.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWStatuesCell: UITableViewCell {
    
    // MARK: - 定义微博配图高度，宽度约束
    var pictureViewHeigthConstriant: NSLayoutConstraint?
    var pictureViewWidthConstriant: NSLayoutConstraint?
    

    // MARK: - blog statues  the cell  only have a statsus
    
    /// this methode as OC  override set
    // 当cell的微博属性改变的时候对更新子控件的status
    var statues: XWSatus?{
    
        didSet{
            
            // 更新topview的属性
            topView.status = statues
            
            // 更新pictureView的属性
            pictureView.status = statues
            
            // 获得自定义size 
            let collectionSize = pictureView.collectionViewSize()
            
            // 当status改变的时候重写设定约束
            pictureViewWidthConstriant?.constant = collectionSize.width
                //size.width
            
            // pictureViewHeigthConstriant 注意别写错
            pictureViewHeigthConstriant?.constant = collectionSize.height
            
            
            contentLabel.text = statues?.text
            
        }
    }
    
    
    // MARK: - the strcture method
    
    // MARK: - 构造函数  in the UITableViewCell
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
    }

    
    // MARK: - prepare UI
    func prepareUI() {
        
        // 添加子控件  contentView
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        
        contentView.addSubview(pictureView)
        
        contentView.addSubview(bottomView)
        
        // 去除autoures
        topView.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束  contentView
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSizeMake(UIScreen.width(), 53))
    
        // 微博信息
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 8, y: 8))
        
        
        // 添加微博信息宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        
//        pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSizeMake(340, 300), offset: CGPointMake(0, 8))
        // 微博高度，宽度约束
        // 错误示范
//        contentView.addConstraint(pictureViewHeigthConstriant!)
//        contentView.addConstraint(pictureViewWidthConstriant!)
        // 从约束数组中找到对应约束
      
        // 底部视图  在pictureView的下方
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSizeMake(UIScreen.width(), 44), offset: CGPoint(x: -8, y: 8))
        
        //(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSizeMake(0,0), offset: CGPoint(x: 8, y: 0))
        
        // 让contentView与bottomView重合
//        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
    }
    
    // MARK: - 返回行高的方法
    // 根据模型的变化来更新行高
    func rowHeight(status: XWSatus) -> CGFloat {
        
        // 更新模型
        self.statues = status
        
        // 更新约束
        layoutIfNeeded()
        
        let MaxY = CGRectGetMaxY(bottomView.frame)
        //print("MaxY\(MaxY)")
        return MaxY
    }
    
    
    
    // MARK: - lazy subviews 懒加载
    
    /// 顶部视图
    private lazy var topView: XWTopView =  XWTopView()
    
    /// 图片视图
    lazy var pictureView: XWPictureView = XWPictureView()
    
    /// 底部视图
    lazy var bottomView: XWBottomView =  XWBottomView()
    
    /// 微博内容
     lazy var contentLabel: UILabel =  {
        
        let label = UILabel(fonsize: 14, textColor: UIColor.blackColor())
        label.numberOfLines = 0
        return label
    }()
    
    
    
    

}