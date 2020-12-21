//
//  ToastView.swift
//  BaseKit
//
//  Created by chen on 2020/5/6.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

public enum LoadingStatus {
    case loading
    case suc
    case blank
    case error
    case netError
}

open class LoadingView: UIView {
    public lazy var _icon = UIImageView() => { it in
        it.contentMode = .scaleAspectFit
    }

    public lazy var _msg = UILabel() => { it in
        it.font = UIFont.systemFont(ofSize: 12)
        it.textColor = color_gray_99
        it.text = "正在加载"
        it.textAlignment = .center
        it.numberOfLines = 0
    }

    public required init() {
        super.init(frame: CGRect.zero)

        addSubview(_icon)
        addSubview(_msg)

        _icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(14)
            $0.left.equalToSuperview().offset(15)
        }

        _msg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(100)
            $0.right.equalToSuperview()
            $0.left.equalTo(_icon.snp.right).offset(5)
        }

//         1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z") => { it in
            // 2.设置动画属性
            it.fromValue = 0 // 开始角度
            it.toValue = Double.pi * 2 // 结束角度
            it.repeatCount = MAXFLOAT // 重复次数
            it.duration = 1
            it.autoreverses = false // 动画完成后自动重新开始,默认为NO
            it.isRemovedOnCompletion = false // 默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        }
        _icon.layer.add(rotationAnim, forKey: nil) // 给需要旋转的view增加动画
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
