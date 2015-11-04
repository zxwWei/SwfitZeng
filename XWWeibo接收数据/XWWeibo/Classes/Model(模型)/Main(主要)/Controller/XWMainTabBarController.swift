//
//  XWMainTabBarController.swift
//  XWWeibo
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWMainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置颜色
        tabBar.tintColor = UIColor .orangeColor()
        
        
        let homeVc = XWHomeTableVC()
        addChildViewController(homeVc, title: "首页", imageName: "tabbar_home")
        
        
        let messageVc = XWMessageTableVC()
        addChildViewController(messageVc, title: "消息", imageName: "tabbar_message_center")
        
        // 往中间加一个控制器  用于占位
        let ButtonVc = UIViewController()
        addChildViewController(ButtonVc, title: "", imageName: "")
        
        
        let discoverVc = XWDiscoverTableVC()
        addChildViewController(discoverVc, title: "发现", imageName: "tabbar_discover")
        
        let profileVc = XWProfileTableVC()
        addChildViewController(profileVc, title: "我", imageName: "tabbar_profile")
        
    }
    
    
//  MARK: - 当界面将出现的时候往其中添加add按钮
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let width = tabBar.bounds.width / 5
        let height = tabBar.bounds.height
        
        compassButton.frame = CGRectMake(width * 2, 0, width, height)
        
        // 往其中添加按钮
        tabBar.addSubview(compassButton)
    }
    
    
//  MARK: - 将导航控制器tabBar嵌套
    func addChildViewController(childController: UIViewController, title: String , imageName: String) {
        
        childController.title = title
//        
//        let nav = UINavigationController()
//        
//        nav.addChildViewController(childController)
//        
//        addChildViewController(nav)
        
        addChildViewController(UINavigationController(rootViewController: childController))
        
        childController.tabBarItem.image = UIImage(named: imageName)
    }
    
    
    // MARK: - 懒加载
    lazy var compassButton: UIButton = {
        let button = UIButton()
        
        // image 用图片的大小填充  backgroundImage  填充整个背景
        
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "toComposeVC", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        return button
    }()
    
    // MARK: - 跳转到发微博界面
    func toComposeVC(){
        // 记得带导航控制条
        presentViewController(  UINavigationController(rootViewController: XWComposeVC()), animated: true, completion: nil)
    }
    
}




