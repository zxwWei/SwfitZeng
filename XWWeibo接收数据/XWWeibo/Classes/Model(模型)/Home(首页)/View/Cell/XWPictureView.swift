//
//  XWPictureView.swift
//  GZWeibo05
//
//  Created by apple1 on 15/11/1.
//  Copyright © 2015年 zhangping. All rights reserved.
//


// MARK : - git clone https://github.com/December-XP/swiftweibo05.git 下载地址
import UIKit
import SDWebImage

let XWPictureViewCellNSNotification = "XWPictureViewCellNSNotification"
let XWPictureViewCellSelectedPictureUrlKey = "XWPictureViewCellSelectedPictureUrlKey"
let XWPictureViewCellSelectedIndexPathKey = "XWPictureViewCellSelectedIndexPathKey"

class XWPictureView: UICollectionView {
    
    // MARK: - 微博模型  相当于重写setter
    var status: XWSatus? {
        didSet{
            
            //print(status?.realPictureUrls?.count)
            reloadData()
        
        }
    }
    
    // 这个方法是 sizeToFit调用的,而且 返回的 CGSize 系统会设置为当前view的size
    override func sizeThatFits(size: CGSize) -> CGSize {
        return collectionViewSize()
    }
    
    
    // MARK: - 根据微博模型,计算配图的尺寸 让cell获得配图的大小
    func collectionViewSize() -> CGSize {
    
        // 设置itemSize
        let itemSize = CGSize(width: 90, height: 90)
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        /// 列数
        let column = 3
        
        /// 间距
        let margin: CGFloat = 10
        
        // 获取微博里的图片个数来计算size 可以为0
        let count = status?.realPictureUrls?.count ?? 0
        
        if count == 0 {
            return CGSizeZero
        }
        
        if count == 1 {  // 当时一张图片的时候，有些图片大，有些小，所以要根据图片的本来大小来调节
            
            // 获取图片url
            let urlStr = status!.realPictureUrls![0].absoluteString
            
            var size = CGSizeMake(150, 120)
            // 获得图片
            if  let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr) {
            
                size = image.size
            }
            // 让cell和collectionView一样大
            
            if (size.width < 40){
                size.width = 40
            }
            
            layout.itemSize = size
            
            return size
        }
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        if count == 4 {
            
            let width = 2 * itemSize.width + margin
            
            return CGSizeMake(width, width)
        }
        
        
        // 剩下 2, 3, 5, 6, 7, 8, 9
        // 计算行数: 公式: 行数 = (图片数量 + 列数 -1) / 列数
        let row = (count + column - 1) / column
        
        // 宽度公式: 宽度 = (列数 * item的宽度) + (列数 - 1) * 间距
        let widht = (CGFloat(column) * itemSize.width) + (CGFloat(column) - 1) * margin
        
        // 高度公式: 高度 = (行数 * item的高度) + (行数 - 1) * 间距
        let height = (CGFloat(row) * itemSize.height) + (CGFloat(row) - 1) * margin
        

        return CGSizeMake(widht, height)
    }

    
    // MARK: - collection Layout
    private var layout  = UICollectionViewFlowLayout()
    
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // layout 需在外面定义，不要使用   init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
  
    init() {
        super.init(frame: CGRectZero, collectionViewLayout:layout)
        
        backgroundColor = UIColor.clearColor()

    
        // 数据源代理
        dataSource = self
        delegate = self
        
        // 注册cell
        registerClass(XWPictureViewCell.self, forCellWithReuseIdentifier: "cell")
        // 准备UI
//        prepareUI()
    }

    
}

// MARK: 数据源方法 延伸 代理延伸
extension XWPictureView: UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status?.realPictureUrls?.count ?? 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! XWPictureViewCell
        
        
        // realPictureUrls里面有着转发微博和原创微博的图片数
        cell.imgUrl = status?.realPictureUrls?[indexPath.item]
        
        return cell
    }
    
    // 当点击cell的时候调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 记录index sttus是从cell处传过来的
        let userInfo: [String: AnyObject] = [
        
            XWPictureViewCellSelectedIndexPathKey  : indexPath.item,
            //MARK: - bug 注意属性间的转换∫
            XWPictureViewCellSelectedPictureUrlKey : status!.realLargePictureUrls!
        ]
        
        // 发送通知 将通知发送到homeVC
        NSNotificationCenter.defaultCenter().postNotificationName(XWPictureViewCellNSNotification, object: self, userInfo: userInfo)
    }
    
}


// MARK: - 自定义cell 用来显示图片
class XWPictureViewCell: UICollectionViewCell{
    
    // MARK: - 属性图片路径  NSURL? 要为空
    var imgUrl: NSURL? {
    
        didSet{
        
            // 不要用错方法
            picture.sd_setImageWithURL(imgUrl)
            
            let gif = (imgUrl!.absoluteString as NSString ) .pathExtension.lowercaseString == "gif"
            
            gifImageView.hidden = !gif
        }
    }
    
  
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }

    
    //  MARK : - 准备UI
    func prepareUI() {
        contentView.addSubview(picture)
        contentView.addSubview(gifImageView)
        
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加约束 充满子控件
        picture.ff_Fill(contentView)
    
        let views = ["gif":gifImageView]
        contentView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("H:[gif]-4-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
         contentView.addConstraints(NSLayoutConstraint .constraintsWithVisualFormat("V:[gif]-4-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
//         gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: contentView, size: nil)
        
    }
    
    // MARK: - 懒加载
    /// 其他图片不需要缓存 设置其适配属性
    private lazy var picture: UIImageView = {
        let imageView = UIImageView ()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// gif图标
    private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
}