//
//  UITextView+extension.swift
//  emotion
//
//  Created by apple1 on 15/11/6.
//  Copyright © 2015年 apple1. All rights reserved.
//

import UIKit

extension UITextView {

    /// 获取带表情图片的文本字符串
    func emoticonText() -> String {
        // 定义可变字符串
        var strM = ""
        
        // 遍历textView里面的每一个文本
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length:attributedText.length ), options: NSAttributedStringEnumerationOptions(rawValue: 0), usingBlock: { (dict , range , _ ) -> Void in
            
            
            if let attachmet = dict["NSAttachment"] as? XWAttachment {
        
                strM += attachmet.name!
            }
            else {
                // 不是附件,截取对应的文本
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                strM += str
            }
            
        })
        return strM
    }

    
    
    // MARK: - 插入表情的方法
     func insertEmotion(emotion: XWEmotion) {
//
//        // 判断文本是否有值
//        guard let textView = self.textView else {
//            print("textView没有值")
//            return
//        }
//        
        // 当是删除按钮时，删除文本
        if emotion.removeEmotion{
            deleteBackward()
        }
        
        
        // 当emoji有值的时候 插入
        if let emoji = emotion.emoji{
            
            insertText(emoji)
        }
        
        // 当图片有路径的时候
        if let pngPath = emotion.pngPath{
            
            
            // 创建附件
            
            let attachment = XWAttachment()
            attachment.name = emotion.chs
            
            //          attachment.image = UIImage(named: pngPath)
            attachment.image = UIImage(contentsOfFile: pngPath)
            
            
            let height = font?.lineHeight ?? 10
            attachment.bounds = CGRect(x: 0, y: -height*0.25, width: height, height: height)
            
            // 创建带附件的属性文本  此时并没有设定font 图片的本质是文字
            let attributeStr = NSAttributedString(attachment:attachment)
            let attstr = NSMutableAttributedString(attributedString: attributeStr)
            
            // NSAttachmentAttributeName 这个属性错误
            attstr.addAttribute(NSFontAttributeName, value: font!, range: NSRange(location:0, length: 1))
            
            // 让textView的文本等于属性文本 这种是完全替代
            //            textView.attributedText = attributeStr
            
            // 取到光标位置
            let selectedRange = self.selectedRange
            
            
            // 获取现有文本  textView.attributedText  让textView的属性文本转化成带附件的属性文本
            let attributeStrM = NSMutableAttributedString(attributedString: attributedText)
            
            // 替代属性文本到对应位置
            attributeStrM.replaceCharactersInRange(selectedRange, withAttributedString: attstr)
            
            // 将文本放在textView
           attributedText = attributeStrM
            
            // 因为光标会自动到最后一位 所以需重新设定光标 偏移到光标的后一位
            self.selectedRange = NSRange(location: selectedRange.location + 1 , length: 0)
            
            // 目的是是发送按钮能被点击
            // 主动调用键盘的通知和textView的代理   ? 前面的执行了才执行后面的
            delegate?.textViewDidChange?(self)
            
            // 主动发送通知
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
        }
    }
    
}