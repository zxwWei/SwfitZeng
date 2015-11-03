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
        
        if !XWUserAccount.userLogin() {
            return
        }
        
        // MARK: - 本身自带的属性 创建下拉刷新控制器
        refreshControl = XWRefrshControl()
        
        
        setupNavigaiotnBar()
        prepareUI()
    
        // MARK: - load the data of blog 从模型处加载数据
        XWSatus.loadTheBlogifnos { (statues, error) -> () in
            
            if (error != nil){
                SVProgressHUD.showErrorWithStatus("error:did not have data of blog", maskType: SVProgressHUDMaskType.Black)
            }
            
            if statues == nil || statues?.count == 0 {
                SVProgressHUD.showInfoWithStatus("没有新的微博数据", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            //print("blog:statues\(statues)")
            
            self.statues = statues
            
            
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
        
        title = XWUserAccount.loadAccount()?.name
    }
    
    
   
    // MARK: - Table view data source

    // 返回行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statues?.count ?? 0
    }
    
    // 返回cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取模型 拆包
        let status = statues![indexPath.row]
        
        let id = status.cellID()
        
        // 根据id来判断是那个模型
        let cell = tableView.dequeueReusableCellWithIdentifier(id)! as! XWStatuesCell
        
        // 将status传给cell
        cell.statues = status
        
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
    
    
    

}
