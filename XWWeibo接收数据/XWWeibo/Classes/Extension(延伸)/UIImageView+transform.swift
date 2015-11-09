//
//  UIImageView+transform.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/9.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWImageView: UIImageView {
    
    //当transform的缩放比例小于指定的最小缩放比例时,设置为指定的最小缩放比例
    override var transform: CGAffineTransform {
    
        didSet {
        
            if transform.a < XWPhotoSelectorScrollViewMinScale {
                
                transform = CGAffineTransformMakeScale(XWPhotoSelectorScrollViewMinScale, XWPhotoSelectorScrollViewMinScale)
            }
        
        }
    }
    
//    // 覆盖父类的属性
//    override var transform: CGAffineTransform {
//        didSet {
//            // 当设置的缩放比例小于指定的最小缩放比例时.重新设置
//            if transform.a < XWPhotoSelectorScrollViewMinScale {
//                print("设置 transform.a:\(transform.a)")
//                transform = CGAffineTransformMakeScale(XWPhotoSelectorScrollViewMinScale, XWPhotoSelectorScrollViewMinScale)
//            }
//        }
//    }
    
}
