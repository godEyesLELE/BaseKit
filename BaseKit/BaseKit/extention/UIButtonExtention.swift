//
//  UIButtonExtention.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/5.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

public typealias buttonClick = (()->()) // 定义数据类型(其实就是设置别名)

public extension UIButton {
    enum XButtonEdgeInsetsStyle {
        case ImageTop // 图片在上，文字在下
        case ImageLeft // 图片在上，文字在下
        case ImageBottom // 图片在上，文字在下
        case ImageRight // 图片在上，文字在下
    }

    /**
     ># Important:按钮图文位置设置
     知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    func layoutButtonWithEdgInsetStyle(_ style: XButtonEdgeInsetsStyle, _ space: CGFloat) {
        // 获取image宽高
        let imageW = imageView?.frame.size.width
        let imageH = imageView?.frame.size.height
        // 获取label宽高
        var lableW = titleLabel?.intrinsicContentSize.width
        let lableH = titleLabel?.intrinsicContentSize.height

        var imageEdgeInsets: UIEdgeInsets = .zero
        var lableEdgeInsets: UIEdgeInsets = .zero
        if frame.size.width <= lableW! { // 如果按钮文字超出按钮大小，文字宽为按钮大小
            lableW = frame.size.width
        }
        // 根据传入的 style 及 space 确定 imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .ImageTop:
            imageEdgeInsets = UIEdgeInsets(top: 0.0 - lableH! - space / 2.0, left: 0, bottom: 0, right: 0.0 - lableW!)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - imageW!, bottom: 0.0 - imageH! - space / 2.0, right: 0)
        case .ImageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - space / 2.0, bottom: 0, right: space / 2.0)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: 0.0 - space / 2.0)
        case .ImageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0.0 - lableH! - space / 2.0, right: 0.0 - lableW!)
            lableEdgeInsets = UIEdgeInsets(top: 0.0 - imageH! - space / 2.0, left: 0.0 - imageW!, bottom: 0, right: 0)
        case .ImageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: lableW! + space / 2.0, bottom: 0, right: 0.0 - lableW! - space / 2.0)
            lableEdgeInsets = UIEdgeInsets(top: 0, left: 0.0 - imageW! - space / 2.0, bottom: 0, right: imageW! + space / 2.0)
        }
        // 赋值
        titleEdgeInsets = lableEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
    // 改进写法【推荐】
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
        /// ...其他Key声明
    }
    /// 运行时关联
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }
    /// 点击回调
    @objc func tapped(button:UIButton){
        if self.actionBlock != nil {
            self.actionBlock!()
        }
    }
    @objc func click(action:@escaping buttonClick) {
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
    }
    /// 快速创建
    convenience init(action:@escaping buttonClick){
        self.init()
        self.addTarget(self, action:#selector(tapped(button:)) , for:.touchUpInside)
        self.actionBlock = action
        self.sizeToFit()
    }
}
