//
//  XWTopView.swift
//  XWWeibo
//
//  Created by apple1 on 15/10/31.
//  Copyright © 2015年 ZXW. All rights reserved.
//

import UIKit

class XWTopView: UIView {
    
    // MARK: - 属性
    var status: XWSatus?{
        
        didSet{
            
            // 用户头像  可选绑定 当有value时进入
            if let iconStr = status?.user?.profile_image_url {
            
                iconView.sd_setImageWithURL(NSURL(string: iconStr))
            }
        
            // 名称
            userName.text = status?.user?.name
            
            // 时间
            timeLabel.text = status?.created_at
            
            // 来源
            sourceLabel.text = "来自**"
            
            // 认证类型
            // 判断类型设置不同的图片
            // 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
            verifiedIcon.image = status?.user?.verifiedTypeImage
            
            // 会员等级
            memberIcon.image = status?.user?.mbrankImage
        
        }
    }
    
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        backgroundColor = UIColor.orangeColor()
        
        prepareUI()
    }


    // MARK: - 准备UI
    private func prepareUI () {
        
        // 分割线
        addSubview(topSeperatorView)
        
        addSubview(iconView)
        addSubview(userName)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(verifiedIcon)
        addSubview(memberIcon)
        
        
        topSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        verifiedIcon.translatesAutoresizingMaskIntoConstraints = false
        memberIcon.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 设定约束
        topSeperatorView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSizeMake(UIScreen.width(), 10))
        
        // 头像
        iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topSeperatorView, size: CGSizeMake(35, 35), offset: CGPoint(x: 8, y: 8))
        
        // 名称
        userName.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        
       
        
        /// 时间
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 0))
        
        /// 来源
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: timeLabel, size: nil, offset: CGPoint(x: 8, y: 0))
        
        /// 会员等级
        memberIcon.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: userName, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 8, y: 0))
        
        /// 认证图标
        verifiedIcon.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: CGSize(width: 17, height: 17), offset: CGPoint(x: 8.5, y: 8.5))
    
    }
    
    
    
    //MARK: - 懒加载
    
    /// 顶部视图
    lazy var topSeperatorView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return view
    }()
    
    /// 用户头像
    private lazy var iconView: UIImageView = UIImageView()
    /// 用户名称
    private lazy var userName: UILabel = UILabel(fonsize: 12, textColor: UIColor.darkGrayColor())
    /// 时间label
    private lazy var timeLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.orangeColor())
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel(fonsize: 9, textColor: UIColor.blackColor())
    /// 认证图标
    private lazy var verifiedIcon: UIImageView = UIImageView()
    /// 会员等级
    private lazy var memberIcon: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    
}
