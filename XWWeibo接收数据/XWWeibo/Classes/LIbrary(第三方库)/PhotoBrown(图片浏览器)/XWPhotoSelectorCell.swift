//
//  XWPhotoSelectorCell.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/9.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit
import SDWebImage

let XWPhotoSelectorScrollViewMinScale: CGFloat = 0.5

class XWPhotoSelectorCell: UICollectionViewCell {
    
    //MARK: -属性
    
    // 当url改变的时候下载图片
    var url: NSURL?  {
        didSet {
            
            guard let iamgeUrl = url else{
                print("没有url")
                return
            }
            
            // 防止cell的重用
            imageView.image = nil
            resertCellProperties()
            
            self.indicator.startAnimating()
            
            // 下载图片
            self.imageView.sd_setImageWithURL(iamgeUrl) { (image , error , _ , _ ) -> Void in
                
                // 如果有错误
                if error != nil {
                    print("有错误")
                    return
                }
                
                //let size = self.displaySize(image)
                // 自动适配
                //self.imageView.sizeToFit()
                
                // 获取图片具体位置
                self.iamgeLocation(image)
                
                self.indicator.stopAnimating()
                
            }
            
        }
    }
    
    // 将cell上子控件scorllView 和imageView的属性重置
    private func resertCellProperties(){
        
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        
        imageView.transform = CGAffineTransformIdentity
    }
    
    
    // MARK: -构造函数
    override init(frame: CGRect) {
       
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 准备UI
    private func prepareUI(){
        
        scrollView.addSubview(imageView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(indicator)
        
        // 添加约束
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["scrollView":scrollView]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // indicator约束
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        setUPScrollView()
    }
    
    // 处理scrollView
    private func setUPScrollView(){
    
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = XWPhotoSelectorScrollViewMinScale
        scrollView.maximumZoomScale = 2.0
        
    }
    
    
    //MARK: -处理图片的方法
    // 处理缩放
    private func displaySize(image: UIImage) -> CGSize{
        
        // 缩减后的高度 ／ 缩减后的宽度 = 原来的高度 / 原来的宽度
        
        let newWidth = scrollView.bounds.width
        let newHeight = newWidth * image.size.height / image.size.width
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    // 处理图片高度大于屏幕时，让他可以滚动  当图片高度小于屏幕时，让他居中显示
    
    private func iamgeLocation(image: UIImage) {
        
        // 新的size
        let size = displaySize(image)
        
        if size.height < UIScreen.height() {
          
            
            let offset = (UIScreen.height() - size.height) * 0.5
            //
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 设置上下可以滚动 顶在中间
            scrollView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: offset, right: 0)
        }
        else{
            
            imageView.frame = CGRect(origin: CGPointZero, size: size)
            
            // 设定滚动范围
            scrollView.contentSize = size
        }
    }
    
    //MARK:- 懒加载
    /// 滚动
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    /// 图像
    lazy var imageView: XWImageView = XWImageView()
    
    /// 进度指示器
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
}

// MARK: - scrollView代理方法
extension XWPhotoSelectorCell: UIScrollViewDelegate {

    
    // 返回的缩放完成的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 正在缩放时调用
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        print("缩放时")
    }
    
    // 结束缩放 此时imageViewbounds不会变 但frame变化  当松手时 系统默认会先回到左上角设置的最小缩放比例处，然后再调用这个方法回到中间 覆盖imageView的transform
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {

            var offsetX = (scrollView.bounds.width - imageView.frame.width) * 0.5
            var offsetY = (scrollView.bounds.height - imageView.frame.height) * 0.5
//         print("\(offsetX) \(offsetY)")
        
           //当 offest < 0 时,让 offest = 0,否则会拖不动
            offsetX = offsetX < 0 ? 0 : offsetX
            offsetY = offsetY < 0 ? 0 : offsetY
        
            UIView.animateWithDuration(0.25) { () -> Void in
                
                // 将图片顶到中间
                scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
        }
    }
}






