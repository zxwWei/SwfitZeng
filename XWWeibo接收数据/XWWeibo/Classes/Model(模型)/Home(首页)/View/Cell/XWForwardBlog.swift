//
//  XWForwardBlog.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/2.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWForwardBlog: XWStatuesCell {
    
    // 覆盖父类的属性监视
    override var statues: XWSatus? {
        
        didSet {
        
            let name = statues?.retweeted_status?.user?.name ?? "名称为空"
            let text = statues?.retweeted_status?.text ?? "信息为空"
            //print("子类:name\(name) text\(text)")
            forWardLabel.text = "@\(name): \(text)"
        }
        
    }
    
    override func prepareUI() {
        super.prepareUI()
        
        contentView.insertSubview(bkgBtn, belowSubview: pictureView)
        contentView.addSubview(forWardLabel)
        
        // 添加约束
        // 背景
        // 左上角约束
        bkgBtn.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -8, y: 8))
        // 右下角
        bkgBtn.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        
        
        // 被转发微博内容label
        forWardLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: bkgBtn, size: nil, offset: CGPoint(x: 8, y: 8))
        // 宽度约束
        contentView.addConstraint(NSLayoutConstraint(item: forWardLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        
        
        // 配图的约束
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: forWardLabel, size: CGSize(width: 0, height: 0), offset: CGPoint(x: 0, y: 8))
        // 获取配图的宽高约束
        pictureViewHeigthConstriant = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewWidthConstriant = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        
        
    }
    
    
    // MARK: - 懒加载
    
    private var bkgBtn: UIButton = {
        
        let btn = UIButton()
        
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1)
    
        return btn
    }()
    
    
    private var forWardLabel: UILabel = {
    
        let forWardLabel = UILabel()
        
        forWardLabel.textColor = UIColor.darkGrayColor()
        forWardLabel.numberOfLines = 0
        
        forWardLabel.text = "测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试"
        return forWardLabel
        
    }()
    
    
    
}
