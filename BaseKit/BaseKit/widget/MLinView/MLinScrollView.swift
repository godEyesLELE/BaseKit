//
//  MLinScrollView.swift
//  BaseKit
//
//  Created by chen on 2020/7/30.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

open class MLinScrollView: UIScrollView {
    open lazy var _mLinView = MLinView(mWidth: .match, mHeight: .match) => { it in
        it.backgroundColor = color_gray_F5
        it.scrollerAble = true
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        addSubview(_mLinView)
        backgroundColor = color_gray_F5
        _mLinView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _mLinView.didMoveToSuperview()
    }
}
