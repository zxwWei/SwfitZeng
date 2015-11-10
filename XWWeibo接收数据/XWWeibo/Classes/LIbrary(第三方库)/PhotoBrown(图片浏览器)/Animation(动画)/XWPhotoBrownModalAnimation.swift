//
//  XWPhotoBrownModalAnimation.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/10.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWPhotoBrownModalAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    
    // 返回动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.25
    }
    
    // 自定义动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取moadl目标控制器的view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView!)
        
        // 设置toView的alpha
        toView?.alpha = 0
        
       UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
        toView?.alpha = 1
        }) { (_ ) -> Void in
            
            transitionContext.completeTransition(true)
        }
        
        
    }

}
