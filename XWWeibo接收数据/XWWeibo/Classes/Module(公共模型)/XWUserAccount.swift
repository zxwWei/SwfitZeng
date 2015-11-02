//
//  XWUserAccount.swift
//  XWWeibo
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import Foundation
import UIKit

class XWUserAccount: NSObject, NSCoding {
    
      //MARK: -  define a userlogin method, when switch controller,we can get a true or false from it
    class func userLogin() -> Bool{
    
        return XWUserAccount.loadAccount() != nil
    }
    
    
    
//    返回值字段	字段类型	字段说明
//    access_token	string	用于调用access_token，接口获取授权后的access token。
//    expires_in	string	access_token的生命周期，单位是秒数。
//    remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
//    uid	string	当前授权用户的UID。
    
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSTimeInterval = 0 {
        didSet{
             expires_date = NSDate(timeIntervalSinceNow: expires_in)
             //print("expires_date:\(expires_date)")
        }
       
    }
    
    /// 当前授权用户的UID。
    var uid: String?
    
    /// 过期时间
    var expires_date: NSDate?
    
    /// 友好显示名称
    var name: String?
    
    /// 头像
    var avatar_large: String?
    
    
    //  MARK: - 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        
        // 将字典里面的每一个属性给模型的每一个属性
        setValuesForKeysWithDictionary(dict)
    }
    
    // 当字典里面的key在模型里面没有对应的属性  调用此方法 "remind_in"没用到
    // ["access_token": 2.00z5K9aCRElhUB0255c5c664pnH2dC, "remind_in": 157679999, "uid": 2370926933, "expires_in": 157679999])
    //override func setValue(value: AnyObject?, forKey key: String) {}
    // MArk: - 要用这个方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 输出
    override var description: String {
        return "access_token:\(access_token), expires_in:\(expires_in), uid:\(uid): expires_date:\(expires_date) name:\(name) avatar_large:\(avatar_large)"
    }
    
    // MArk: - 保存和读取
    static let accountPath = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"
    
    // 保存
    func saveAccount() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: XWUserAccount.accountPath)
        //print("XWUserAccount.accountPath:\(XWUserAccount.accountPath)")
    }
    
    /// 静态帐号   func loadAccount() -> XWUserAccount? reback a useraccuont
    private static var userAccount: XWUserAccount?
    
    //MARK:-  每次都进来解档账户  现在想只加载一次，保存到内存中以后访问内存中的帐号
    // 读取 XWUserAccount?类方法  accountPath: 新的路径
    class  func loadAccount() -> XWUserAccount? {
        
        // 当内存中没有时才解档
        if userAccount == nil{
           userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? XWUserAccount
        }
        else{
           // print("加载内存中的帐号")
        }
        //&& userAccount?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending
        // 判断帐号是否过期  expires_date?.compare  > nsdate返回的期限
        if userAccount != nil  {
            //print("帐号有效")
            return userAccount
        }
        //print("accountPath:\(accountPath)")
        return nil
    }
    
    // MARK: - 加载用户信息  不管成功失败都要告诉调用者
    func loadUserinfo(finished:(error: NSError?) -> ()){
        
        
        // 准备闭包
        XWNetworkTool.shareInstance.loadUserinfo { (result, error) -> () in
            
            if (error != nil) || result == nil{
                
                print("error\(error)")
                
                finished(error: error)
                print("加载用户数据失败")
                return
            }
           
            // 加载数据成功 将值赋给属性
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            // 保存到沙盒
            self.saveAccount()
            
            // 同步属性到内存中
            XWUserAccount.userAccount = self
            
            
                 //print("XWUserAccount.userAccount\(XWUserAccount.userAccount)")
            finished(error: nil)
        }
    }
    
    // MARK: - 归档和解档
    // 归档
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(access_token, forKey: "access_token")
        encoder.encodeDouble(expires_in, forKey: "expires_in")
        encoder.encodeObject(uid, forKey: "uid")
        encoder.encodeObject(expires_date, forKey: "expires_date")
        encoder.encodeObject(name, forKey: "name")
        encoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    // 解档
    required init?(coder decoder: NSCoder) {
        access_token = decoder.decodeObjectForKey("access_token") as? String
        expires_in = decoder.decodeDoubleForKey("expires_in")
        uid = decoder.decodeObjectForKey("uid") as? String
        expires_date = decoder.decodeObjectForKey("expires_date") as? NSDate
        // 归档
        name = decoder.decodeObjectForKey("name") as? String
        avatar_large = decoder.decodeObjectForKey("avatar_large") as? String
    }
    
    
    
    
    
    
}