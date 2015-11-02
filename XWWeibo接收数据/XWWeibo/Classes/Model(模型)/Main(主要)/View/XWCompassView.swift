//
//  XWCompassView.swift
//  XWWeibo
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

// MARK: - 代理协议
protocol XWCompassViewDelegate: NSObjectProtocol {
    
    func vistorWillRegegister()
    func vistorWillLogin()
    
}

class XWCompassView: UIView {

// MARK: - 判断遵守代理的控制器是否遵守代理方法
    weak var vistorDelegate: XWCompassViewDelegate?
    
    func willRegister() {
        // 如果遵守代理执行?后面的方法
        vistorDelegate?.vistorWillRegegister()
    }
    
    func willLogin() {
        vistorDelegate?.vistorWillLogin()
    }
    
    

// MARK: - 初始化方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepareUi()
    }

// MARK: - 准备UI
    func prepareUi() {
    
        // 往view添加子控件
        addSubview(rotationIconView)
        addSubview(coverImage)
        addSubview(homeView)
//      addSubview(coverImage)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        
        // 设置约束
        rotationIconView.translatesAutoresizingMaskIntoConstraints = false
        homeView.translatesAutoresizingMaskIntoConstraints = false
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 添加约束
        // 转轮 centerX
        addConstraint(NSLayoutConstraint(item: rotationIconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: rotationIconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
        
        
        // 小房子
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rotationIconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: homeView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: rotationIconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        
        // 信息
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: homeView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: homeView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 44))
        // 信息的宽度
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 240))
        

        // 登陆按钮
        // 左边
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        // 顶部
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        // 宽度
         addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        // 高度
         addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 36))
        
        
        
        // 注册按钮
        // 右边
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        // 顶部
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        // 宽度
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        // 高度
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 36))
        
        // 渲染图层
        // 左边
        addConstraint(NSLayoutConstraint(item: self.coverImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.coverImage, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: self.coverImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        // 与注册按钮约定约束
        addConstraint(NSLayoutConstraint(item: self.coverImage, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.registerButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
        
    }

// MARK: - 不同的控制器显示不同的信息
    func setupVistorView(message: String, rotationViewName: String){
        homeView.hidden = true
        
        rotationIconView.image = UIImage(named: rotationViewName )
        messageLabel.text = message;
        // 将子控件放在最下面
        sendSubviewToBack(coverImage)
    }
    
// MARK: - 旋转方法
    func rotation(){
        
        // 创建动画对象
        let anim = CABasicAnimation()
        // transform.rotation
        anim.keyPath = "transform.rotation"
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        
        // 完成时不移除动画
        anim.removedOnCompletion = false

        rotationIconView.layer.addAnimation(anim, forKey: "rotation")
    }
    
    
    /// 暂停旋转
    func pauseAnimation() {
        // 记录暂停时间
        let pauseTime = rotationIconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        // 设置动画速度为0
        rotationIconView.layer.speed = 0
        
        // 设置动画偏移时间
        rotationIconView.layer.timeOffset = pauseTime
    }
    
    /// 恢复旋转
    func resumeAnimation() {
        // 获取暂停时间
        let pauseTime = rotationIconView.layer.timeOffset
        
        // 设置动画速度为1
        rotationIconView.layer.speed = 1
        
        rotationIconView.layer.timeOffset = 0
        
        rotationIconView.layer.beginTime = 0
        
        let timeSincePause = rotationIconView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
        
        rotationIconView.layer.beginTime = timeSincePause
    }
    
    
// MARK: - 懒加载

    /// 旋转的图像
    private lazy var rotationIconView: UIImageView = {
        
        let iconView = UIImageView()
        iconView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
       
        // 自动适配图像
        iconView.sizeToFit()

        return iconView
    }()
    
    /// 小房子
    private lazy var homeView: UIImageView = {
       let homeView = UIImageView()
        
        homeView.image = UIImage(named: "visitordiscover_feed_image_house")
        
        homeView.sizeToFit()
        
        return homeView
    }()
    
    /// 信息
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        
        messageLabel.text = "想看更多的好东西吗"
        messageLabel.textColor = UIColor.blackColor()
        
        // 设置分行
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.sizeToFit()
        
        return messageLabel
        }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let registerButton = UIButton()
        
        registerButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        registerButton.setTitle("注册", forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        registerButton.addTarget(self , action: "willRegister", forControlEvents: UIControlEvents.TouchUpInside)
        
        registerButton.sizeToFit()
        
        return registerButton
        }()
    
    /// 登陆按钮
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        
        // setBackgroundImage 才会切割
        loginButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        loginButton.setTitle("登陆", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        loginButton.addTarget(self , action: "willLogin", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.sizeToFit()
        
        return loginButton
    }()
    
    /// 渲染图层
    private lazy var coverImage: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
}









