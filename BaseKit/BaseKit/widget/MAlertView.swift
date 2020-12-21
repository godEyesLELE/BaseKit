//
//  UIAlertView.swift
//  BaseKit
//
//  Created by chen on 2020/5/7.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

open class MAlertView: UIView {
    open var cancelAble: Bool = true
//        {
//        didSet {
//            isUserInteractionEnabled = cancelAble
//        }
//    }
    var keyboardChangeAction: ((_ keyboardHeight: CGFloat)->())? = nil
    open lazy var tap = UITapGestureRecognizer(target: self, action: #selector(clickOutSide))
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundColor = UIColor.black.withAlphaComponent(0.52)
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        tap.delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 消失

    @objc public func clickOutSide() {
        if !cancelAble { return }
        dismiss()
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha = 0
        }, completion: { it in
            if it {
                self.removeFromSuperview()
            }
        })
    }
    
    /** 指定视图实现方法 */
    public func show() {
        alpha = 0
        UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self)

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        })
    }
    
    /** 键盘变化后需要的动作*/
    public func keyboardChangeListen(keyboardChangeAction: @escaping (_ keyboardHeight: CGFloat)->()) {
        self.keyboardChangeAction = keyboardChangeAction
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - 键盘将要弹出
    @objc func keyboardWillChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.frame)
            //改变下约束
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.keyboardChangeAction?(intersection.height)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    deinit {
        tap.delegate = nil
        try? NotificationCenter.default.removeObserver(self)
    }
}
extension MAlertView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tap {
            if touch.view == self {
                return true
            }
            return false
        }
        return true
    }
}
