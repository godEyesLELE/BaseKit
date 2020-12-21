//
//  ToastUtil.swift
//  BaseKit
//
//  Created by chen on 2020/4/23.
//  Copyright © 2020 chen. All rights reserved.
//
import UIKit

open class ToastUtil: NSObject {
    public class func toastSuc(message: String?, completion: (() -> Void)? = nil) {
        toast(message: message, completion: completion)
    }

    public class func toastWarn(message: String?, completion: (() -> Void)? = nil) {
        toast(message: message, "hud_hp_warning", completion: completion)
    }

    public class func toastError(message: String?, completion: (() -> Void)? = nil) {
        toast(message: message, "hud_hp_error", completion: completion)
    }

    public class func showLoading(message: String?, completion: (() -> Void)? = nil) {
        toast(message: message, "hud_hp_loading", autoHide: false, completion: completion)
    }

    // 显示消息
    public class func toast(message: String?, _ icon: String = "hud_hp_success", autoHide: Bool = true, completion: (() -> Void)? = nil) {
        let aShowTime: TimeInterval = 2.0
        if Thread.current.isMainThread {
            customToast = currentCustomToast()
            customToast?.removeFromSuperview()
            customToast?._icon.layer.removeAllAnimations()
            customToast?.layer.removeAllAnimations()

            let AppDlgt = UIApplication.shared.delegate!
            AppDlgt.window?!.addSubview(customToast!)

            customToast?._msg.text = message as String?
            customToast?._icon.image = UIImage(named: icon)
            customToast?.alpha = 0

            if !autoHide {
                // 1.创建动画
                let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z") => { it in
                    // 2.设置动画属性
                    it.fromValue = 0 // 开始角度
                    it.toValue = Double.pi * 2 // 结束角度
                    it.repeatCount = MAXFLOAT // 重复次数
                    it.duration = 1
                    it.autoreverses = false // 动画完成后自动重新开始,默认为NO
                    it.isRemovedOnCompletion = false // 默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
                }
                customToast?._icon.layer.add(rotationAnim, forKey: nil) // 给需要旋转的view增加动画
            }

            customToast?.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(SCREEN_HEIGHT * 0.05)
            }
            customToast?.superview?.layoutIfNeeded()

            UIView.animate(withDuration: (aShowTime - 1) / 2, delay: autoHide ? 0 : 0.15, animations: {
                customToast?.alpha = 1

                customToast?.snp.remakeConstraints {
                    $0.centerX.equalToSuperview()
                    $0.top.equalToSuperview().offset(getNavbarHeight() + 10)
                }
                customToast?.superview?.layoutIfNeeded()
            }) { _ in
                if autoHide {
                    UIView.animate(withDuration: (aShowTime - 1) / 2, delay: 1, options: .curveEaseOut, animations: {
                        customToast?.alpha = 0
                        customToast?.snp.remakeConstraints {
                            $0.centerX.equalToSuperview()
                            $0.top.equalToSuperview().offset(SCREEN_HEIGHT * 0.05)
                        }
                        customToast?.superview?.layoutIfNeeded()
                    }) { _ in
                        //                    customToast?.removeFromSuperview()
                        completion?()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.toast(message: message)
            }
            return
        }
    }

    public class func hideLoading() {
        let aShowTime: TimeInterval = 2.0
        UIView.animate(withDuration: (aShowTime - 1) / 2, delay: 0, options: .curveEaseOut, animations: {
            customToast?.alpha = 0
            customToast?.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(SCREEN_HEIGHT * 0.05)
            }
            customToast?.superview?.layoutIfNeeded()
        }) { _ in
            customToast?._icon.layer.removeAllAnimations()
            customToast?.layer.removeAllAnimations()
        }
    }
}

// MARK: init UI

extension ToastUtil {
    public static var customToast: ToastView?
    public class func currentCustomToast() -> ToastView {
        objc_sync_enter(self)
        if customToast == nil {
            customToast = ToastView() => { it in
                it.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                it.layer.masksToBounds = true
                it.layer.cornerRadius = 20.0
                it.alpha = 0
            }
        }
        objc_sync_exit(self)
        return customToast!
    }
}
