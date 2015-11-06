//
//  ViewController.swift
//  emotion
//
//  Created by apple1 on 15/11/5.
//  Copyright © 2015年 apple1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 输入窗口
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        textView.inputView = collectionVC.view
        
        collectionVC.textView = textView
        
        text()
    }

    /// 懒加载
    private lazy var collectionVC: XWEmotionVc = XWEmotionVc()
    
  
    @IBAction func click(sender: AnyObject) {
        let strM = textView.emoticonText()
        print("strM: \(strM)")
    }
    
    
    func text(){
        //print("\(textView.attributedText)")
        
  
        
    }

}

