//
//  WarningAlertView.swift
//  BaseKit
//
//  Created by chen on 2020/5/19.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

open class WarningAlertView: MAlertView {
    lazy var _backgroundView = UIView() => { it in
        it.backgroundColor = color_white
        it.layer.cornerRadius = 8
        it.clipsToBounds = true
    }

    private lazy var _contentLb = UILabel() => { it in
        it.textColor = color_gray_22
        it.font = UIFont.systemFont(ofSize: 17)
        it.textAlignment = .center
        it.text = "提示语"
        it.numberOfLines = 0
    }

    private lazy var _separtorH = UIView() => { it in
        it.backgroundColor = color_gray_DD
    }
    
    private lazy var _separtorV = UIView() => { it in
        it.backgroundColor = color_gray_DD
    }

    public lazy var _leftButton = UIButton(type: .custom) => { it in
        it.setTitle("取消", for: .normal)
        it.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 17.0)!
        it.setTitleColor(color_gray_99, for: .normal)
        it.click { [weak self] in
            self?.dismiss()
        }
    }

    public lazy var _rightButton = UIButton(type: .custom) => { it in
        it.setTitle("确定", for: .normal)
        it.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 17.0)!
        it.setTitleColor(color_theme, for: .normal)
        it.setTitleColor(color_theme_light, for: .disabled)
    }

    public init(msg: String) {
        super.init()
        addSubview(_backgroundView)
        cancelAble = false
        _backgroundView.addSubview(_contentLb)
        _backgroundView.addSubview(_separtorH)
        _backgroundView.addSubview(_rightButton)
        _backgroundView.addSubview(_leftButton)
        _backgroundView.addSubview(_separtorV)

        _backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.greaterThanOrEqualTo(130)
            $0.height.lessThanOrEqualTo(250)
        }
        _contentLb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.greaterThanOrEqualTo(48)
        }
        _separtorH.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(_contentLb.snp.bottom).offset(18)
        }
        _rightButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.left.equalTo(_leftButton.snp.right)
            $0.height.equalTo(44)
            $0.top.equalTo(_separtorH.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        _leftButton.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(_separtorH.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(0)
        }
        _separtorV.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.top.equalTo(_separtorH)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        _separtorV.isHidden = true
        _leftButton.isHidden = true

        _contentLb.text = msg
        
    }
    
    public func setConfirm(confirm: String = "确定", textColor: UIColor = color_theme, confirmBlock: @escaping (_ warningAlert: WarningAlertView) -> Void = { $0.dismiss() }) -> WarningAlertView{
        _rightButton.setTitle(confirm, for: .normal)
        _rightButton.setTitleColor(textColor, for: .normal)
        _rightButton.click { confirmBlock(self) }
        return self
    }

    public func setCancel(cancel: String = "取消", textColor: UIColor = color_gray_99, cancelBlock: @escaping (_ warningAlert: WarningAlertView) -> Void = { $0.dismiss() })  -> WarningAlertView {
        
        _leftButton.isHidden = false
        _separtorV.isHidden = false
        _leftButton.snp.remakeConstraints {
            $0.left.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(_separtorH.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(_rightButton.snp.width)
        }
        _leftButton.setTitle(cancel, for: .normal)
        _leftButton.setTitleColor(textColor, for: .normal)
        _leftButton.click { cancelBlock(self) }
        return self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
