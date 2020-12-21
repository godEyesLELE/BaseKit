//
//  ToastView.swift
//  BaseKit
//
//  Created by chen on 2020/5/6.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit
open class ToastView: UIView {
    public lazy var _icon = UIImageView(image: UIImage(named: "hud_hp_success")) => { _ in
    }

    public lazy var _msg = UILabel() => { it in
        it.font = UIFont.systemFont(ofSize: 14)
        it.textColor = .white
        it.text = ""
        it.textAlignment = .center
        it.numberOfLines = 0
    }

    public required init() {
        super.init(frame: CGRect.zero)

        addSubview(_icon)
        addSubview(_msg)

        _icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
            $0.left.equalToSuperview().offset(15)
        }

        _msg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.lessThanOrEqualTo(300)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.right.equalToSuperview().offset(-15)
            $0.left.equalTo(_icon.snp.right).offset(8)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
