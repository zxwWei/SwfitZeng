//
//  XWPlacerholderTextView.swift
//  XWWeibo
//
//  Created by apple1 on 15/11/4.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

// MARK: - 自定义textview 添加隐式文字

class XWPlacerholderTextView: UITextView {
    
    // placehoder
    
    var placerdoler: String? {
        didSet {
            
            placeholerlabel.text = placerdoler
            placeholerlabel.sizeToFit()
        }
        
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        prepareUI()
        
        // 添加通知事件，当textview里面的内容发生改变的时候，监听通知  object通知的发送者
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange:", name: UITextViewTextDidChangeNotification, object: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  准备UI
    private func prepareUI() {
        
        addSubview(placeholerlabel)
        
        placeholerlabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: placeholerlabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: placeholerlabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5))
        
    }
    
    // MARK: - bug 私有的属性和方法要加@obj    记得将自己也传过来　
    @objc  private func textDidChange(notificition: NSNotification){
        
        // 能到这里来说明是当前这个textView文本改变了
        // 判断文本是否为空: hasText()
        // 当有文字的时候就隐藏
        placeholerlabel.hidden = hasText()
        
    }
    
    // 移除通知
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // placehoderLabel
    // 外界要使用 不要私有　
    private lazy var placeholerlabel: UILabel = {
        
        let label = UILabel()
        
        
        // 设置字体大小
        label.font = UIFont.systemFontOfSize(18)
        
        // 设置文字颜色
        label.textColor = UIColor.lightGrayColor()
        
        return label
        }()
    
}