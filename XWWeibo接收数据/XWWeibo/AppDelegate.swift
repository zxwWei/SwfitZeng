//
//  AppDelegate.swift
//  XWWeibo
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 启动时输出保存的数据
        //print("启动 account:\(XWUserAccount.loadAccount())")
        
        
        // MARK: - 在一开始的时候设置导航条全局属性
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
            
        // 设置frame
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        // ? 有值的时候执行后面的代码
        window?.makeKeyAndVisible()
        //print("初始化")
        // 创建tabbar
        //let tabBarVc = XWMainTabBarController()
        
        
        //window?.rootViewController = XWWelcomeVC()
        
        window?.rootViewController = defaultController()
        
        //window?.rootViewController = tabBarVc
        
        getVersion()
        return true
    }
    
    
    // MARK: - 根据版本号来判断进入那一个控制器
    
    func defaultController() -> UIViewController {
        
        // if did not have account show tabbar
        if !XWUserAccount.userLogin() {
            
//            return XWMainTabBarController()
        }
        
        
        return getVersion() ? XWNewFeatureVC() : XWWelcomeVC()
    }
    
    // 判断版本号
    func getVersion() -> Bool {
    
        // 获取当前的版本号
        let curretnVersionStr = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        //  将其转换成double
        let curretnVersion = Double(curretnVersionStr)!
        
        //print("curretnVersion\(curretnVersion)")
        
        
        // 获取之前的版本号
        let sandBoxVersionKey = "sandBoxVersionKey"
        let sandBoxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(sandBoxVersionKey)
        //print("sandBoxVersion\(sandBoxVersion)")
        
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(curretnVersion, forKey: sandBoxVersionKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        return  curretnVersion > sandBoxVersion
    }
    
    
    // 根据需要切换控制器
     func switchRootController(isMain: Bool){
        
        window?.rootViewController = isMain ? XWMainTabBarController() : XWWelcomeVC()
    }
    
    
}




