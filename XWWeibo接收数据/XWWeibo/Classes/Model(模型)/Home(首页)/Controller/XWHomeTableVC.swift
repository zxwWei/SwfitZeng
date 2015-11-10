//
//  XWHomeTableVC.swift
//  XWWeibo
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SVProgressHUD

// MARK: - 统一管理两个cell
enum XWCellReuseIndentifier: String {
    case ownCell = "ownCell"
    case forWardCell = "forWardCell"
    
}

class XWHomeTableVC: XWcompassVc {
    
    // MARK: - define a modelArray of blog  this tableview have many cell
    private var statues: [XWSatus]?{
       
        didSet{
            tableView.reloadData()
        }
    }

    
    // MARK : - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("测试")
        
        // 将下拉的菊花放在底部块   // 添加footView,上拉加载更多数据的菊花
        tableView.tableFooterView = pullUpView
        
        if !XWUserAccount.userLogin() {
            return
        }
        
        // MARK: - 本身自带的属性 创建下拉刷新控制器
        refreshControl = XWRefrshControl()
        
        // 下拉后自动刷，添加对应事件 当值改变的时候调用
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        // 调用beginRefreshing开始刷新,但是不会触发 ValueChanged 事件,只会让刷新控件进入刷新状态
        refreshControl?.beginRefreshing()
        
        // 代码触发 UIControlEvents.ValueChanged 事件
        refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        setupNavigaiotnBar()
        
        prepareUI()

        // 注册配图通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectedPicture:", name: XWPictureViewCellNSNotification, object: nil)
}
    
    // 执行 接收到图片url 点击图片后接收到通知
    func didSelectedPicture(notification:NSNotification){
        //MARK: -bug 看清楚输出的参数
        //print("notification\(notification)")
        
        guard let urls = notification.userInfo!["XWPictureViewCellSelectedPictureUrlKey"] as? [NSURL] else {
        
            return
        }
        
        guard let selectIndex = notification.userInfo!["XWPictureViewCellSelectedIndexPathKey"] as? Int else{
        
            return
        }
        
        let controller = XWPictureBrownVC(urls: urls, selectIndex: selectIndex)
        
        // 设置modal控制器的转场代理
        //controller.transitioningDelegate = controller
        
        // TODO: 转场动画 设置modal控制器的转场样式
        //controller.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        
        // 弹出照片浏览器
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    // 注销通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - 加载数据  用户从模型加载数据
    func loadData() {
        if (!XWUserAccount.userLogin()){
            return
        }
        print("加载微博数据")
        // 默认是下拉刷新, 取得id最大的微博，如果没有数据，默认是20条微博
        // var since_id = statues?.first?.id ?? 0
        // var max_id = 0
        // 这样的话值没有改变过
        // MARK: - bug 后面要使用和判断 since_id
        var since_id = statues?.first?.id ?? 0
        var max_id = 0
        //var cnt =  8
        // 下拉加载
        if pullUpView.isAnimating(){
             since_id =  0
             max_id = statues?.last?.id ?? 0
        }
        // MARK: - load the data of blog 从模型处加载数据 用户从模型加载数据 发送网络请求，收到新的微博
        XWSatus.loadTheBlogifnos(since_id, max_id: max_id) { (statuses, error) -> () in
            
            // 下拉刷新的时候，将下拉刷新停止
            self.refreshControl?.endRefreshing()
            // 加载数据的时候,将菊花停止
            self.pullUpView.stopAnimating()
            if (error != nil){
                SVProgressHUD.showErrorWithStatus("error:did not have data of blog", maskType: SVProgressHUDMaskType.Black)
            }
            
//            print("statuses\(statuses)")
            // MARK: - 判断的是statuses
            if statuses == nil || statuses?.count == 1 {
                self.showNumberOfBlog(0)
//                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            //print(since_id)
            // 当 since_id大于0的时候加载
            if (since_id > 0){
                //print("下拉刷新,获取到: \(statuses?.count)");
                self.statues = statuses! + self.statues!
                let count = statuses?.count
                self.showNumberOfBlog(count!)
            }
            else if (max_id > 0){
                //print("上拉加载更多数据,获取到: \(statuses?.count)");
                self.statues = self.statues! + statuses!
            }
            else{
                self.statues = statuses
                //print("获取最新20条数据.获取到 \(statuses?.count) 条微博")
            }
            
        }
    }
    
    // MARK: - 显示下拉刷新了多少条微博
    func showNumberOfBlog(count: Int){
        
        let labelHeight: CGFloat = 44
        
        // 添加label
        let label = UILabel()
        label.frame = CGRectMake(0, -20 - labelHeight, UIScreen.width(), labelHeight)
        
        label.text = count == 0 ? "没有新的微博" : "刷新了\(count)条微博)"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor.orangeColor()
        
        // 将label插入到导航条的最下方
        navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            // 显示在导航条底部 44开始
            label.frame.origin.y = labelHeight
            
            }) { (_ ) -> Void in
                
                UIView.animateKeyframesWithDuration(1, delay: 0.3, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: { () -> Void in
                    
                    // 显示回原处
                    label.frame.origin.y = -20 - labelHeight
                    
                    }, completion: { (_ ) -> Void in
                        // 移除
                        label.removeFromSuperview()
                        
                })
        }
        
    }
    
    
    // MARK: 准备UI
    private func prepareUI() {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // talbeView注册cell  XWOwnBlog  XWForwardBlog
        tableView.registerClass(XWOwnBlog.self, forCellReuseIdentifier: XWCellReuseIndentifier.ownCell.rawValue)
        tableView.registerClass(XWForwardBlog.self, forCellReuseIdentifier: XWCellReuseIndentifier.forWardCell.rawValue)
    
    }
    
     // MARK: - setupNavigaiotnBar
     private func setupNavigaiotnBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // TODO: 底部为什么也是名字
        navigationItem.title = XWUserAccount.loadAccount()?.name
//        title = XWUserAccount.loadAccount()?.name
    }
    
    
   
    // MARK: - Table view data source

    // 返回行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statues?.count ?? 0
    }
    
    // MARK: - 返回cell  在这里上拉加载更多数据
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取模型 拆包
        let status = statues![indexPath.row]
        
        let id = status.cellID()
        
        // 根据id来判断是那个模型
        let cell = tableView.dequeueReusableCellWithIdentifier(id)! as! XWStatuesCell
        
        // 将status传给cell
        cell.statues = status
        
        if indexPath.row == statues!.count - 1 && !pullUpView.isAnimating() {
            // 菊花转起来
            pullUpView.startAnimating()
            
            // 上拉加载更多数据
            loadData()
        }
        
        
        return cell
    }

    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
       
        // 取得模型
        let status = statues![indexPath.row]
        
        // 判断缓存中有没有行高
        if let rowHeight = status.rowHeight {
            return rowHeight
        }
        
        // 如果status原型里面有 转发模型则返回转发模型的cell标记
        let id = status.cellID()
        
        //  获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(id) as! XWStatuesCell
        
        // 调用方法获取行高
        let rowHeight = cell.rowHeight(status)
        
        // 将其保存在缓存
        status.rowHeight = rowHeight
         //print("rowHeight\(rowHeight)")
        return rowHeight
    }
    
    // MARK: - 懒加载
    /// 上拉加载更多数据显示的菊花
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        indicator.color = UIColor.magentaColor()
        
        return indicator
        }()
    
}

    

