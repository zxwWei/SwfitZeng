//
//  XWComposeVC.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/4.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWComposeVC: UIViewController {

    /**
    定义toolBar的底部约束
    */
    private var bottomConstriant: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // 设置背景
        view.backgroundColor = UIColor.whiteColor()
        // 添加键盘frame 改变事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        prepareUI()
    }

    // MARK: - 键盘通知事件
    func keyboardWillChangeFrame(notificition: NSNotification){
        //print("notificition\(notificition)")
        
        // 获取动画时间 记得转换
        let duration = notificition.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! NSTimeInterval
        let endframe = notificition.userInfo!["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
        
        bottomConstriant?.constant = -(UIScreen.height() - endframe.origin.y)
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            // 更新约束
            self.view.layoutIfNeeded()
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
    
        //  记得调用
        setUpNavigation()
        setUPToolBar()
        setUpTitle()
        // MARK: - bug 当tabbar约束完成才可以关联与其相关的约束
        setUPTextView()
      
    }
    
    // MARK: - 用户一进入变成第一使用者
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
////        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
////        view.backgroundColor = UIColor.redColor()
////        textView.inputView = view
//        
//        // 自定义键盘其实就是给 textView.inputView 赋值
//        
//        textView.becomeFirstResponder()
//    }
    
    
    
    // MARK: 设置导航条
    private func setUpNavigation() {
        //  navigationController?. 不是从这开始 // 记得带导航控制条
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "backToMain")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发微博", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        
        navigationItem.rightBarButtonItem?.enabled = false
        
    }

    // MARK: - 设置toolBar
    private func setUPToolBar(){
        
        // 添加子控件
        view.addSubview(toolBar)
        
        // 添加约束
         let cons =  toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44))
        
        // 获取某约束
        bottomConstriant = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
//        toolBar.backgroundColor = UIColor.redColor()
    
        //  取得图片名字对应的数组  "action": "picture" 事件 可防止图片位置改变 造成点击事件的混乱
        let itemSettings = [
            ["imageName": "compose_toolbar_picture", "action": "picture"],
            ["imageName": "compose_emoticonbutton_background", "action": "emoticon"],
            ["imageName": "compose_trendbutton_background", "action": "trend"],
            ["imageName": "compose_mentionbutton_background", "action": "mention"],
            ["imageName": "compose_addbutton_background", "action": "add"]
        ]
        
        // 创建　items数组
        var items = [UIBarButtonItem]()
        
        
        // 遍历名字数组, 对其背景图片进行赋值
        for dict in itemSettings {
            
            // 获取图片名字
            let imageName = dict["imageName"]!
            
            // 获取动作名称
            let action = dict["action"]!
            
            let item = UIBarButtonItem(imageName: imageName)
            
            // 让item的自定义view成为button
            let button = item.customView as! UIButton
            
            button.addTarget(self, action:Selector(action) , forControlEvents: UIControlEvents.TouchUpInside)
            
            // 将item拼接进items
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        
        } 
        
        // 移除最后一个弹簧
        items.removeLast()

        //  让toolBar自带的items成为此时的items
        toolBar.items = items
    }
    
    // MARK: - 按钮点击事件
    func picture() {
        print("图片")
    }
    
    func trend() {
        print("#")
    }
    
    func mention() {
        print("@")
    }
    
    func emoticon() {
        print("表情")
    }
    
    func add() {
        print("加号")
    }
    
    // MARK: - 设置标题
    private func setUpTitle() {
        
        let prefix = "发微博"
        
        //  name =  XWUserAccount.loadAccount()?.name
        if  let name =  XWUserAccount.loadAccount()?.name {
        
            let nameStr = prefix + "\n" + name
            let lable = UILabel()
            
            // 创建可变的属性文本
            let attributetext = NSMutableAttributedString(string: nameStr)
            
            // 获得某位置后的文本
            let nameRange = (nameStr as NSString).rangeOfString(name)
            
            lable.textAlignment = NSTextAlignment.Center
            lable.font = UIFont.systemFontOfSize(14)
            lable.numberOfLines = 0
            
            // 设置文本属性
            attributetext.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: nameRange)
            attributetext.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: nameRange)
            
            // 将他赋值给label
            lable.attributedText = attributetext
            // 必须要注意位置
            lable.sizeToFit()
            
            navigationItem.titleView = lable
        }
        else{
            navigationItem.title = prefix
        }
    
    }
    
    // MARK: - 设置文本
    private func setUPTextView() {
        
        view.addSubview(textView)
        
        // 设置约束
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil)
        // 在toolbar的顶部右上方
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolBar, size: nil)
        
    }
    
    // 返回主界面 @objc让oc语法也可以访问
    @objc private func backToMain() {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
 
    // MARK: 懒加载
     /// 懒加载toolBar
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return toolBar
    }()
    
    /// 懒加载textView
    private lazy var textView: XWPlacerholderTextView = {
        let textView = XWPlacerholderTextView()
        
            textView.backgroundColor = UIColor.orangeColor()
            textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            textView.font = UIFont.systemFontOfSize(18)
        
            // 设置代理
            textView.delegate = self
        
            //MARK: - 应该是对placerdoler进行操作
//          textView.placeholerlabel.text = "分享新鲜事"
            textView.placerdoler = "分享新鲜事..."
            // 设置textView有回弹效果
            textView.alwaysBounceVertical = true
            // MARK: - bug 当textView拖的时候 键盘消失   若键盘没出现是因为硬件keyboard被设置为隐藏
            textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return textView
    }()
}

extension XWComposeVC: UITextViewDelegate{

    /// textView文本改变的时候调用
    func textViewDidChange(textView: UITextView) {
        // 当textView 有文本的时候,发送按钮可用,
        // 当textView 没有文本的时候,发送按钮不可用
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }

}







