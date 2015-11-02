                                    //
//  XWOauthVC.swift
//  XWWeibo
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SVProgressHUD // 指示器

class XWOauthVC: UIViewController {

    // 在loadview的时候将view设成webView
    override func loadView() {
        view = webView
        
        webView.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brownColor()
        title = "新浪微博登陆"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        
        // 加载网页 
        let request = NSURLRequest(URL: XWNetworkTool.shareInstance.oauthURL())
        webView.loadRequest(request)
        
    }

// MARK: - 退出当前页面
    func close(){
        
        dismissViewControllerAnimated(true, completion: nil)
    }

// MARK: - 懒加载
    private lazy var webView = UIWebView()
}

// MARK: - 扩展 webView代理方法
extension XWOauthVC: UIWebViewDelegate {
    
    //MARK: - 开始加载
    func webViewDidStartLoad(webView: UIWebView) {
        
        // 状态按钮
        SVProgressHUD.showWithStatus("正在玩命在加载", maskType: SVProgressHUDMaskType.Black)
        
       
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
//            
//             self.netError("网络不给力")
//            
//        })
    }
    
    // MARK: - 加载完成时状态按钮消失
    func webViewDidFinishLoad(webView: UIWebView) {
        
        SVProgressHUD.dismiss()
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 询问是否加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
        // 1.根据重定向的地址来获取code
        let urlString = request.URL!.absoluteString
        //print("urlString\(urlString)")
        
        // 2.如果加载的不是回调地址,可以加载
        if !urlString.hasPrefix(XWNetworkTool.shareInstance.redirect_uri){
            
            return true
        }
        
        //urlStringhttp://www.baidu.com/?code=c188681987de38eddb88d2f957751082
        if let  query = request.URL!.query{
        
            //print("query: \(query)")
            // MARK: bug: code=eb1374691dbd47c151b96932a1aa1c18  要将code=去掉
            let codeString = "code="
            
            // 3.如果有code字样的前缀
            if query.hasPrefix(codeString){
                
                // 截取code
                
                // 转换成字符串
                let nsQuery = query as NSString
                
                let code = nsQuery.substringFromIndex(codeString.characters.count)
                //print("code:\(code)")
                // 获取code去获取AssesToken
                loadAssesToken(code)
                
            }
            else{
                // 取消
                
            }
        }
        
        
        return false
    }
    
    // MARK: - 加载AssesToken
    func loadAssesToken(code: String){
        
        // 加载AssesToken 通过调用方法获取闭包回调数据
        XWNetworkTool.shareInstance.loadAssesToken(code) { (result, error) -> () in
            //print("error\(error)")
            // 如果出错时执行以下方法
            if (error != nil || result == nil)
            {
                self.netError("网络不给力")
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    
                    self.close()
                })
                return
            }
            // 成功时调用
            print("result:\(result)")
            // 将获取到的数据保存沙盒
            // 创建模型
            let account = XWUserAccount(dict: result!)
            
            // 保存帐号到沙盒
            account.saveAccount()
          
            // MARK: -  加载用户数据  新的API   name     avatar-large // 头像  
            // 加载用户信息
            account.loadUserinfo({ (error) -> () in
                    //print("loadUserinfo:error\(error)")
                // 在这里测试才能看到错误  错误传给外界执行
                if error != nil {
                    
                    self.netError("加载用户错误")
                    return
                }
            })
            
            print("accountFinished:\(XWUserAccount.loadAccount())")
            
            // when login succesful, switch to welcomeVC
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).switchRootController(false)
            SVProgressHUD.dismiss()
//            self.close()
        }
        

    }
    
    // MARK: - 错误提示
    private func netError(message: String){
    
          SVProgressHUD.showErrorWithStatus(message, maskType: SVProgressHUDMaskType.Black)
        self.close()
    }
    
}






