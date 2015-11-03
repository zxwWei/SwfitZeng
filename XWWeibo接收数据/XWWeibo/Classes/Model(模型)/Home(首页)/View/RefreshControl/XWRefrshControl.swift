//
//  XWRefrshControl.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/3.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWRefrshControl: UIRefreshControl {
    
    let offsetHeigth: CGFloat = -60
    private var isUp  = false
    
    // MARK: - 监听tableView的frame的变化来确定箭头的旋转 覆盖父类方法
    override var frame: CGRect{
        didSet {
            //print("frame\(frame)")
            
            // refreshing 如果在加载数据 开始转菊花
            if refreshing {
            
                refreshView.startLoading()
            }
            
            
            if frame.origin.y > 0 {
                return
            }
            
            if frame.origin.y < offsetHeigth && !isUp {
            
                print("箭头朝上")
                isUp = true
                refreshView.rotationTipViewIcon(isUp)
            }
            if frame.origin.y > offsetHeigth && isUp{
                print("箭头朝下")
                isUp = false
                refreshView.rotationTipViewIcon(isUp)
            }
        }
    }
    
    
    // MARK: - 重写下拉刷新方法
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.startLoading()
    }
    

    // MARK: -构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override init() {
        super.init()
        
        
        addSubview(refreshView)
        
        // 添加约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }

 
        private lazy var refreshView: XWRefreshView = XWRefreshView.refreshView()
}


class XWRefreshView: UIView {

    
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    
    @IBOutlet weak var tipViewIcon: UIImageView!
    /// 获取xib
    class func refreshView() -> (XWRefreshView){
    
        return NSBundle.mainBundle().loadNibNamed("XWRefreshView", owner: nil,options: nil).last as! XWRefreshView
        
    }
    
    /**
    箭头旋转动画
    - parameter isUp: true,表示朝上, false,朝下
    */
    func rotationTipViewIcon(isUp: Bool) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.tipViewIcon.transform = isUp ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        }
    }
    
    /// 菊花开始旋转
    func startLoading() {
        // 如果动画正在执行,不添加动画
        let animKey = "animKey"
        
        // 获取图层上所有正在执行的动画的key
        if let _ = loadingView.layer.animationForKey(animKey) {
            // 找到对应的动画,动画正在执行,直接返回
            return
        }
        
        tipView.hidden = true
        
        // 旋转
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = M_PI * 2
        anim.duration = 0.25
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        
        // 开始动画,如果名称一样,会先停掉正在执行的,在重新添加 防止动画叠加
        loadingView.layer.addAnimation(anim, forKey: animKey)
    }
    
    /// 菊花停止旋转
    func stopLoading() {
        // 显示tipView
        tipView.hidden = false
        
        // 停止旋转
        loadingView.layer.removeAllAnimations()
    }
    
    
}



