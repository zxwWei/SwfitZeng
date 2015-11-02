//
//  XWcompassVc.swift
//  XWWeibo
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZXW. All rights reserved.
//

// MARK: - 让所有的四个控制器继承自它，让它们没登陆的时候都实现如下业务逻辑 显示这个界面
import UIKit

class XWcompassVc: UITableViewController{

    // MARK: -  when user has login ,we can in other vc
    var userLogin = XWUserAccount.userLogin()
    //var userLogin = false
    
//    var vistorView: XWCompassView?
    
    // 当加载view的时候   如果用另外的view代替原有的view，则不再往下执行
    
    override func loadView() {
        
        // 当登陆成功的时候加载原先的view 不成功的时候加载 自定义的view
        userLogin ? super.loadView() : setupVistorView()
        
    }
    
    private func setupVistorView(){
        
        // 为什么要用XWCompassView呢 
        // 转换成xwcompassView
        let vistorView = XWCompassView()
        view = vistorView
        
        
        // 根据控制器的不同显示不同的信息
        if (self is XWHomeTableVC){
            
            vistorView.rotation()
            
            // 监听进入后台和前台的通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        }
        else if (self is XWMessageTableVC){
            vistorView.setupVistorView("你妹", rotationViewName: "visitordiscover_image_message")

        }
        else if (self is XWDiscoverTableVC){
            vistorView.setupVistorView("坑", rotationViewName: "visitordiscover_image_message")
        }
        else if (self is XWProfileTableVC){
            vistorView.setupVistorView("坑爹", rotationViewName: "visitordiscover_image_profile")
        }
        
        // MARK: -  注册代理
        vistorView.vistorDelegate = self
        
        // 添加左边和右边的导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorWillRegegister")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "vistorWillLogin")
         //vistorView.backgroundColor = UIColor.whiteColor()
    }

// MARK: - 监听通知
    func didEnterBackground(){
        // 进入后台暂停旋转
        (view as! XWCompassView).pauseAnimation()
    }
    func didBecomeActive(){
        (view as! XWCompassView).resumeAnimation()
    }
}

// MARK: - 延伸 代理方法的实现  放在控制器外
extension XWcompassVc: XWCompassViewDelegate {
    
    func vistorWillRegegister() {
        print("vistorWillRegegister")
    }
    
    func vistorWillLogin() {
        //print("vistorWillLogin")
        let loginVc = XWOauthVC()
        // 记得添加导航条
        presentViewController(UINavigationController(rootViewController: loginVc), animated: true, completion: nil)
        
    }
}
