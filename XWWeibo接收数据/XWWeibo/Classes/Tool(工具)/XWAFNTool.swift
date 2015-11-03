//
//  XWAFNTool.swift
//  XWWeibo
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 ZXW. All rights reserved.
//


// MARK : - ios9中的网络请求需配key
// MARK : - 进一步封装

import Foundation
import AFNetworking

// MARK: - 网络枚举错误
enum XWNetWorkError: Int {
    case emptyToken = -1
    case emptyUid = -2
    
    // 枚举里面可以有属性
    var description: String {
        get {
            // 根据枚举的类型返回对应的错误
            switch self {
            case XWNetWorkError.emptyToken:
                return "accecc token 为空"
            case XWNetWorkError.emptyUid:
                return "uid 为空"
            }
        }
    }
    
    // 枚举可以定义方法
    func error() -> NSError {
        return NSError(domain: "cn.itcast.error.network", code: rawValue, userInfo: ["errorDescription" : description])
    }
    
}


//class XWNetworkTool: AFHTTPSessionManager {
class XWNetworkTool: NSObject {
    
    /// 闭包宏定义  类型别名
    
    typealias NetWorkFinishedCallBack = (result: [String: AnyObject]?, error: NSError?) -> ()
    
    
    /// 属性  afnManager
    private var afnManager: AFHTTPSessionManager
    
    // MARK: - 1.创建单例 继续自本类
    static let shareInstance: XWNetworkTool = XWNetworkTool()
    
    // MARK: -  重写XWNetworkTool()构造方法
    override init(){
         let urlStr = "https://api.weibo.com/"
         afnManager = AFHTTPSessionManager(baseURL: NSURL(string: urlStr))
         afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    
    }

    
    // MARK: - 2 Oauth授权url  注意参数不要复制出错
    // 2.参数
    // 申请时应用时分配的APPKey
    private let client_id = "1369851949"
    
    // 回调地址
    let  redirect_uri = "http://www.baidu.com/"
    
    /// 请求的类型，填写authorization_code
    private let grant_type = "authorization_code"
    
    // 应用的secert
    private let client_secret = "abc9cd7b14e70a7b26ad4e1cfa147e0e"
    
    //  MARK: - 3.OAthURL地址 Oauth授权url
    func oauthURL() -> NSURL {
        
        // 拼接
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
       
        return NSURL(string: urlString)!
    }
    
    // MARK: - /// 判断access token是否有值,没有值返回nil,如果有值生成一个字典
    
    func assTokenDict() -> [String: AnyObject]? {
        
        if XWUserAccount.loadAccount()?.access_token == nil {
            return nil
        }
        return ["access_token": XWUserAccount.loadAccount()!.access_token!]
        
    }
    
    
    // MARK: - 4.加载AssesToken
    func loadAssesToken(code: String , finished: NetWorkFinishedCallBack){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        // 参数
        let parameters = [
            //"code" : code
            "client_id" : client_id ,
            "client_secret": client_secret,
            "grant_type": grant_type,
            "code": code,
            "redirect_uri": redirect_uri
        ]

        
        
        // MARK: - 网络请求 让调用者获取信息
        afnManager.POST(urlString, parameters: parameters, success: { (_, result) -> Void in
            
            // 成功时告诉调用闭包者得到result
            finished(result: result as? [String: AnyObject] , error: nil)
            
            }) { (_, error) -> Void in
            
            // 失败时告诉调用闭包者得到error
            finished(result: nil, error: error)
        }
        
    }
//    finished: (result: [String: AnyObject]? ,error: NSError?) -> ()  NSError?
       // MARK: - 获取用户信息
    func loadUserinfo(finished:NetWorkFinishedCallBack) {
        
        print("asscess_token:\(XWUserAccount.loadAccount()?.access_token)")
        if XWUserAccount.loadAccount()?.access_token == nil {
            
        let error = XWNetWorkError.emptyToken.error()
            
            finished(result: nil, error: error)
            
            //print("没有acces_token")
            return
        }
        // 判断uid
        if XWUserAccount.loadAccount()?.uid == nil{
            //print("没有uid")
            let error = XWNetWorkError.emptyUid.error()
            
            finished(result: nil, error: error)
            return
        }
        
        // url
        let urlString = "2/users/show.json"
        
        // MARK: -------------------- 参数  字典参数是-------------------
        let parameters = [
            "access_token" : XWUserAccount.loadAccount()!.access_token!,
            "uid" : XWUserAccount.loadAccount()!.uid!
        ]
        
        
        // 把结果告诉调用者
        requestGETGET(urlString, parameters: parameters, finished: finished)
        
    }
    
    ///  visist to blog get the message of blog
    func getblogInfo(finished:NetWorkFinishedCallBack){
    
        let uslStr = "2/statuses/home_timeline.json"
        
        
//        guard  let  parmeters = assTokenDict() else {
//            
//            // 没有值的时候进入
//            finished(result: nil, error: XWNetWorkError.emptyToken.error())
//            return
//        }
        
        
        let parmeters = [
            
            "access_token" : XWUserAccount.loadAccount()!.access_token!
        ]
//
        
        requestGETGET(uslStr, parameters: parmeters, finished: finished)
        
    }
//
//         func getblogInfo(finished:NetWorkFinishedCallBack) {
//        // 获取路径
//        let path = NSBundle.mainBundle().pathForResource("statuses", ofType: "json")
//        
//        // 加载文件数据
//        let data = NSData(contentsOfFile: path!)
//        
//        // 转成json
//        do {
//            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
//            // 有数据
//            finished(result: json as? [String : AnyObject], error: nil)
//        } catch {
//            print("出异常了")
//        }
//    }
//    
    
    
    // MARK: - 封装 GET
    func requestGETGET(URLString: String, parameters: AnyObject?, finished: NetWorkFinishedCallBack){
        
        
        afnManager.GET(URLString, parameters: parameters, success: { (_, result) -> Void in
            
            finished(result: result as? [String: AnyObject], error: nil)
            
            //print("成功:result\(result)")
            
            }) { (_, error ) -> Void in
                
                finished(result: nil, error: error )
               // print("失败:error\(error)")
        }
        
        
        
    }
    
    
    
    
    
    
}



