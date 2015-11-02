//
//  XWWelcomeVC.swift
//  XWWeibo
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SDWebImage

class XWWelcomeVC: UIViewController {
    
    // 定义底部约束
    private var iconBottomConstriant: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        // 有值时进入
        if let urlStr = XWUserAccount.loadAccount()?.avatar_large{
            
            // MARK: - 未完成 从网上下载图片 从网络上获取图片资源
            iconView.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "avatar_default_big"))
        }
      
    }
    
// MARK: - 当界面出现时，出现动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        iconBottomConstriant?.constant = -(UIScreen.mainScreen().bounds.height - 160)
        
        // 有弹簧效果的动画
        // usingSpringWithDamping: 值越小弹簧效果越明显 0 - 1
        // initialSpringVelocity: 初速度

        UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
            }, completion: { (_) -> Void in
                
            
                UIView.animateWithDuration(1, animations: { () -> Void in
                    
                    self.welcomeLabel.alpha = 1
                    
                    }, completion: { (_) -> Void in
                    
                    // MARK: - 当显示完成时做的事 进入访客视图
                    ((UIApplication.sharedApplication().delegate) as! AppDelegate).switchRootController(true)
                        
                })
                
        })
        
    }
    
    

// MARK: - 布局UI
    private func prepareUI() {
        
        // 添加子控件
        view.addSubview(bgView)
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // 添加约束 这是数组
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : bgView]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bkg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bkg" : bgView]))
        
        // 头像
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
        
        view.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))

        // 垂直 底部160
        iconBottomConstriant = NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160)
        view.addConstraint(iconBottomConstriant!)
        
        
        // 欢迎归来
        // H
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: welcomeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        
    
    }
    
    
    
    
// MARK: 准备界面元素
    /// 背景图片
   private lazy var bgView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
   
    /// 欢迎归来
    private lazy var welcomeLabel: UILabel = {
        let  welcomeLabel = UILabel()
        
        welcomeLabel.text = "欢迎归来"
        
        welcomeLabel.alpha = 0
        return welcomeLabel
    }()
    
    /// 头像
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        iconView.layer.cornerRadius = 42.5
        iconView.clipsToBounds = true
        
        
        return iconView
    }()
    
    
    
}
