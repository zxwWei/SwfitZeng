//
//  XWPhotoDismissAnimation.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/10.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWPhotoDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    
    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.25
    }
    
    // 自定义动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }

}
