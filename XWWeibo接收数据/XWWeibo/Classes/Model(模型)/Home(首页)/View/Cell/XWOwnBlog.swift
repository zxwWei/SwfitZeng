//
//  XWOwnBlog.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/2.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWOwnBlog: XWStatuesCell {

    
    // 重写父类方法
    override func prepareUI() {
        super.prepareUI()
        // pictureView  Horizontal  注意是在水平哈
        let cons =  pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 0, height: 0), offset: CGPointMake(0, 8))
        pictureViewHeigthConstriant = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewWidthConstriant = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
    }
    
}
