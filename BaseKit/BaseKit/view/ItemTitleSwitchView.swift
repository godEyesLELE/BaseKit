//
//  ItemTitleSwitchView.swift
//  BaseKit
//
//  Created by wanghaipeng on 2020/6/9.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit
import RxSwift
open class ItemTitleSwitchView: UIView {
    public let _title = UILabel()
    public let _switcher = UISwitch()
    public let _seperator = UIView()
    public typealias SwitchChangeBlock = (_ contentView: ItemTitleSwitchView, _ isOn: Bool) -> Void
    public var _switchBlock: SwitchChangeBlock?
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(title: String = "标题", isOn: Bool = false, style: Style = Style(), switchBlock: SwitchChangeBlock? = nil) {
        super.init(frame: CGRect.zero)
        configUI(style: style)
        makeConstraints()
        
        _switchBlock = switchBlock
        _title.text = title
        _seperator.isHidden = !style.showSeperator
        _switcher.isOn = style.switchOn
    }
    func configUI(style: Style) {
        
        backgroundColor = color_white
        addSubview(_title)
        _title.font = UIFont.systemFont(ofSize: 16)
        _title.textColor = style.titleColor
        
        addSubview(_switcher)
        _switcher.isOn = style.switchOn
        //添加状态变化监听器
        _switcher.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        
        addSubview(_seperator)
        _seperator.backgroundColor = color_gray_EF
    }
    func makeConstraints() {
        _title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(_switcher.snp.leading)
            $0.height.equalTo(22)
            $0.bottom.equalToSuperview().offset(-14)
        }
        _switcher.snp.makeConstraints({
            $0.centerY.equalTo(_title)
            $0.right.equalToSuperview().offset(-15)
        })
        _seperator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(_title)
            $0.height.equalTo(0.5)
        }
    }

    @objc
    func switchDidChange(_ sender: UISwitch){
          //打印当前值
        _switchBlock?(self, sender.isOn)
    }
}
