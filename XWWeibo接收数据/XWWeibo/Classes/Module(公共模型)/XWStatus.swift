//
//  XWStatus.swift
//  XWWeibo
//
//  Created by apple1 on 15/10/31.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SDWebImage

class XWSatus: NSObject {
    
//    修改 Status 模型的 loadStatus方法,添加 since_id 和 max_id 参数
    
//    ///加载大于since_id大的微博
//    var since_id: Int?
//    
//    /// 加载小于或等于max_id的微博
//    var max_id: Int?
    /// 微博创建时间
    var created_at: String?
    
    /// 字符串型的微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?
    
    /// 微博来源
    var source: String?
    
    /// 微博的配图   此时是字典数组  需要将其转换成url数组
    var pic_urls: [[String: AnyObject]]? {
        
        didSet{
        
            // 当字典转模型的时候 将 pic_urls 转换成url赋给pictureUrlS数组
            
            // 判断有没有图片
            let count = pic_urls?.count ?? 0
            
            if count == 0 {
                return
            }
            
            // 创建url数组
            pictureUrlS = [NSURL]()
            
            for dict in pic_urls! {
                
                // 当是这个字典的时候
                if let urlStr = dict["thumbnail_pic"] as? String {
                    
                    // 拼接数组
                    pictureUrlS?.append(NSURL(string: urlStr)!)
                }
            
            }
        
        }
    }
    
    /// 微博配图 url数组
    var pictureUrlS: [NSURL]?
    
    
    /// 计算型属性 如果是转发的返回原创微博的图片 ，转发的返回转发的图片
    var realPictureUrls: [NSURL]? {
        
        get {
        
            // 当模型里面没有 retweeted_status的属性的时候 返回模型原有的pictureUrlS
            return retweeted_status == nil ? pictureUrlS : retweeted_status!.pictureUrlS
        }
    
    }
    
    
    /// 被转发微博
    var retweeted_status: XWSatus?
    
    // 根据模型里面的retweeted_status来判断是原创微博还是转发微博
    /// 返回微博cell对应的Identifier
    func cellID() -> String {
        // retweeted_status == nil表示原创微博
        return retweeted_status == nil ? XWCellReuseIndentifier.ownCell.rawValue :  XWCellReuseIndentifier.forWardCell.rawValue
        
    }
    
    /// 用户模型
    var user: XWUser?
    
    /// 缓存行高
    var rowHeight: CGFloat?
    
    // MARK: - the dictionary transform to model
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // KVC赋值每个属性的时候都会调用 因为status里面有这些字典 现在将他们转成模型
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // because the user is model
        // 判断user赋值时, 自己字典转模型
        //        print("key:\(key), value:\(value)")
        if key == "user" {
            // let the dictionnary which include the message of user into its class let it transform to dictionary itself
            if let dict = value as? [String: AnyObject] {
                // 字典转模型
                // 赋值
                user = XWUser(dict: dict)
                // 一定要记得return
                return
            }
        }
        
        // 将转发的微博转成模型 注意 {} 啊
        else if key == "retweeted_status" {
                if let dict = value as? [String: AnyObject]{
                
                    // 将转发的微博转成模型
                    retweeted_status = XWSatus(dict: dict)
                }
                return
        }
        return super.setValue(value, forKey: key)
    }
    
    
    // MARK: - when some properties from netWork , but we did not has in this dictionary, must 
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK: - the ouput
    override var description: String {
        //        "access_token:\(access_token), expires_in:\(expires_in), uid:\(uid): expires_date:\(expires_date), name:\(name), avatar_large:\(avatar_large)"
        
        let p = ["created_at", "idStr", "text", "source", "pic_urls", "user"]
        // 数组里面的每个元素,找到对应的value,拼接成字典
        // \n 换行, \t table  since_id
        return "\n\t微博模型:\(dictionaryWithValuesForKeys(p))"
    }
    
    
    // MARK: -  加载微博信息 模型从网络处加载数据 该方法让控制器调用
    
    class func loadTheBlogifnos(since_id: Int ,max_id: Int ,finished:(statuses: [XWSatus]? , error: NSError?)->()){
    
        // let netWorkTool load the blogStatus
        
        //  从网络工具类处加载数据
        XWNetworkTool.shareInstance.getblogInfo(since_id , max_id: max_id) { (result, error) -> () in
            
            if (error != nil){
                
                finished(statuses: nil, error: error)
                return
            }
            
            // statuses  result?["statuses"]
            // when status has value , we append it, then give to other  [[String: AnyObject]]  the array of dictionary
            if let array = result?["statuses"] as? [[String: AnyObject]]{
            
                // 创建微博数组
                var statues = [XWSatus]()
                
                for dict in array {
                    
                    statues.append(XWSatus(dict: dict))
                }
                
                // 将图片缓存下来
                cacheWedImage(statues, finised: finished)
                
                finished(statuses: statues, error: nil)
                
            }
            else{
            
                finished(statuses: nil, error: nil)
            }
            
        }
    }
    
    // MARK: TODO: 缓存图片
    class func cacheWedImage(status: [XWSatus]? , finised:(status: [XWSatus]? , error: NSError?) -> ()){
    
        // 定义任务组
        let group = dispatch_group_create()
        
        guard let statusList = status else {
            
            return
        }
        
        // 长度
        var length = 0
        
        // 遍历list数组里面的微博，获取到urlss数组
        for status in statusList{
        
            //获得url数组
            guard let urls = status.realPictureUrls else {
            
                // 没有的时候继续遍历list中的status
                continue
            }
            
            // 根据遍历url数组来缓存图片
            for url in urls {
                // 进入任务组
                dispatch_group_enter(group)
                
                // 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error , _ , _ , _ ) -> Void in
                    // 离开任务组
                    dispatch_group_leave(group)
                    
                    
                    if (error != nil){
                        
                        finised(status: nil, error: error)
                        return
                    }
                    
                    // 拼接长度
                    if let data  = UIImagePNGRepresentation(image){
                    
                         length += data.length
                    }
                    
                       //print("长度:\(length / 1024)")
                })// 注意这个括号
            }
        }
        // 出任务组
        dispatch_group_notify( group, dispatch_get_main_queue() ) { () -> Void in
        
         
            finised(status: status, error: nil)
            
        }
        
        
    }
    
    
}

