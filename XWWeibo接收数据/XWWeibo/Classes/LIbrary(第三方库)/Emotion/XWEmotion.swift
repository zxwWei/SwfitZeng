//
//  XWEmotion.swift
//  emotion
//
//  Created by apple1 on 15/11/5.
//  Copyright © 2015年 apple1. All rights reserved.
//

import UIKit

// MARK:-  表情包模型
class XWEmotionPackge: NSObject {

    // MARK: 属性
    /// 每次从磁盘加载耗性能  第一次从本地加载表情包数据后保存在内存中，以后在内存中加载
    static let packages = XWEmotionPackge.packges()
    
    private static let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")!
    
    ///-  表情包文件夹
    var id: String?
    
    /// 表情名称
    var group_name_cn: String?
    
    /// 表情模型数组
    var emotions: [XWEmotion]?
    
    /// 构造模型方法
    init(id: String) {
        self.id = id
        super.init()
    }
    
    /// 对象打印方法
    override var description: String {
        return "表情包模型: id:\(id), group_name_cn:\(group_name_cn), emoticons:\(emotions)"
    }

    
    // MARK:- 加载包表情包数据 返回表情包模型数组    获取到每个表情包的路径
    private class  func packges() -> [XWEmotionPackge] {
        print("创建")
        // 加载emotion.bundel里面数据
        // let bundlePath = NSBundle.mainBundle().bundlePath
        
        // 获取emotion.plist路径 拼接
        let plistPath = (bundlePath as NSString).stringByAppendingPathComponent("emoticons.plist")
        
        // 加载emotion.plist里面的内容 拆包
        let emotiondict = NSDictionary(contentsOfFile: plistPath)!
        
        // 获取packege数组 转换成字典数组
        let packageArr = emotiondict["packages"] as! [[String: AnyObject]]
        
        //  定义接收表情包模型数组
        var  packges = [XWEmotionPackge]()
        
        // 创建最近表情包
        let recent = XWEmotionPackge(id: "")
        
        
        // MARK: - recent:[表情包模型: id:Optional(""), group_name_cn:nil, emoticons:nil]
        // 此时应该实例化表情模型数组
        recent.emotions = [XWEmotion]()
        
        // 添加追加空白按钮和删除按钮 数据:packges:[表情包模型: id:Optional(""), group_name_cn:nil, emoticons:nil]
        recent.addEmptyEmotion()
        
        // 设置名字
        recent.group_name_cn = "最近"
        // 将最近表情包拼接进数组
        packges.append(recent)
        
        //print("packges:\(packges)")
    
        
        // 遍历 packege数组内容　创建表情包模型数组
        for dict in packageArr {
        
            let id = dict["id"] as! String
            
            // 将具体的id赋到表情包属性上  让下面调用的时候 可以直接获得各表情包的具体plist路径
            let packge = XWEmotionPackge(id: id)
            
            //TODO: maybe 在这里 让表情包进一步去加载表情模型出来
            packge.loadEmotion()
            
            packges.append(packge)
        }
        //print("packges\(packges)")
        return packges
    }
    
    // MARK: - 加载表情包里的表情和其他数据  找到了个表情包的路径 获取表情包模型数组 将其赋值到属性 进入了当组
    func loadEmotion(){
     
        // 获取某plsit的路径 注意  /
        let plistPath = XWEmotionPackge.bundlePath +  "/" + id! + "/info.plist"
        
        // 加载plist里面的内容 拆包
        let infodict = NSDictionary(contentsOfFile: plistPath)!
        
        // 获取表情包名称
        group_name_cn = infodict["group_name_cn"] as? String
        
        // 定义接收表情模型数组
        emotions = [XWEmotion]()
        
        // 记录现在 是第几个表情
        //index ++          //index++
        
        // 记录当前是第几个按钮
        var index = 0
        // 获取表情模型   取得每1个表情然后拼接进去
        if let array = infodict["emoticons"] as? [[String: String]] {
            // 遍历表情数据数组
            for dict in array {
                // 字典转模型,创建表情模型
                emotions?.append(XWEmotion(id: id, dict: dict))
                
                index++
                // 如果是最后一个按钮就添加一个带删除按钮的表情模型
                if index == 20 {
                    emotions?.append(XWEmotion(removeEmotion: true))
                    
                    // 记得重置为0在重新计算
                    index = 0
                }
                
            }
        }
        
        addEmptyEmotion()

       // print("emotions\(emotions)")
    }
    
    //MARK:- 添加空按钮和删除按钮
    private func addEmptyEmotion(){
    
        //print("count\(emotions!.count)")
        //  let count = emotions!.count % 21 ?? 0
        let count = emotions!.count % 21
        // count > 0
        //MARK: bug -  每组有21个 当不满21个时 count>0  emotions!.count == 0 时
        // count等于0时也要进入
        if count > 0 || emotions!.count == 0 {
            
            // 遍历count 到20
            for _ in count..<20 {
                
                // 创建空模型
                emotions?.append(XWEmotion(removeEmotion: false))
            }
            
            // 追加删除按钮
            emotions?.append(XWEmotion(removeEmotion: true))
            
        }
    }
    
// MARK: - 添加最近添加表情进最近表情包
    class func addRecentEmotion(emotion:XWEmotion){
    
        // 如果是删除按钮，不执行
        if emotion.removeEmotion{
            return
        }
        
        // 使用次数增加 times并没有增加
        emotion.times++
        //print("emotion:\(emotion)count:\(emotion.times)")
        
        //MARK: bug取到最近表情包中的表情数组 这个从packages取出 之前是用 private class func packges()-> [XWEmotionPackge] 这个方法取出来操作的不是同一个对象
        var recentEmotionPackage = packages[0].emotions
        
        //print("\(recentEmotionPackage)")
        // 记录最后一个删除按钮
        let removeBtn = recentEmotionPackage!.removeLast()
        
         //判断数组有没有某个表情
        let contains = recentEmotionPackage!.contains(emotion)
        
        //print("contains:\(contains)")
        // 当数组中没有这个表情的时候才添加
        if !contains {
            // 往表情数组其中添加表情 添加一个 后面再删除一个
            // 直接添加在数组的后面,并没有显示出来.将使用次数多的放在最前面.在 CZEmoticon 添加 time 属性,用于记录使用次数
            recentEmotionPackage?.append(emotion)
        }
    
        //print("\(packages[0].emotions)")
        //print("contains\(contains)")
   
        
        // 排序 将使用次数多的放在前面
        recentEmotionPackage = recentEmotionPackage?.sort({ (e1, e2) -> Bool in
            
            return e1.times > e2.times
        })
        
        // 始终删除最后一个 保证一直都是21个，而且最后一个是删除按钮
        if !contains{
            recentEmotionPackage!.removeLast()
        }
        
        // 最后将删除按钮添加回去
        recentEmotionPackage!.append(removeBtn)
        
        // 需要重新赋值回去
        packages[0].emotions = recentEmotionPackage
         //print("\(packages[0].emotions)")
    }
    
}


/* MARK: ------------------------------------------------------------------*/
// MARK: - 表情模型
class XWEmotion: NSObject {


    /// 表情包文件夹名称
    var id: String?
    
    /// 表情名称,用于网络传输
    var chs: String?
    
    /// 表情图片对应的名称
    // 直接使用这个名称是加载不到图片的,因为图片的是保存在对应的文件夹里面
    var png: String? {
    
        didSet {
        
            // 拼接完成路径
            pngPath = XWEmotionPackge.bundlePath + "/" + id! + "/" + png!
        }
    }
    
    /// 记录最近表情使用的次数 times: Int = 0
    // var times: Int = 0
    var times = 0
    
    /// 完整的图片路径 = bundle + id + png
    var pngPath: String?
    
    /// emoji表情对应的16进制字符串
    var code: String? {
        didSet {
            guard let co = code else {
                // 表示code没值
                return
            }
            
            // 将code转成emoji表情
            let scanner = NSScanner(string: co)
            
            // 存储扫描结果
            // UnsafeMutablePointer<UInt32>: UInt32类型的可变指针
            var value: UInt32 = 0
            
            scanner.scanHexInt(&value)
            
            let c = Character(UnicodeScalar(value))
            
            emoji = String(c)
        }
    }
    
    /// emoji表情 本质是字符串
    var emoji: String?
    
    
    /// 创建带删除按钮的单个表情模型
    /// true表示 带删除按钮的表情模型, false 表示空的表情模型
    var removeEmotion: Bool = false
    
    /// 带删除按钮的表情模型, 空模型
    /// 通过这个构造方法创建的模型, 要么是 带删除按钮的表情模型, 要么是 空模型
    /// 带这个属性的模型 removeEmotion
    init(removeEmotion: Bool){
        
        self.removeEmotion = removeEmotion
        super.init()
    }
    
                                                                                                                                                 
    /// 字典转模型
    init(id: String?, dict: [String: AnyObject]){
        
        self.id = id
        
        super.init()
        // KVC 赋值 对
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 字典的key在模型里面没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    /// 打印方法
    override var description: String {
        return "\n\t\t表情模型: chs: \(chs), png: \(png), code: \(code))"
    }
    
}
