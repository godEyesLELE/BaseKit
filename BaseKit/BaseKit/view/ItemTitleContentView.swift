//
//  DateTypeItemView.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/3.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

public class Style {
    public var showSeperator = true
    public var contentGravity: Gravity = .right
    public var showArrow: Bool?
    public var titleColor = color_gray_33
    public var contentColor = color_gray_99
    public var placeholdColor = color_gray_BB
    public var editabled = true
    public var isSecureTextEntry = false
    // switch
    public var switchOn = false
    
    public init() {
        
    }
}

public enum Gravity {
    case left
    case right
}

open class ItemTitleContentView: UIView {
    public let _icon = UIImageView()

    public let _title = UILabel()

    public let _content = UITextField()

    public let _arrow = UIImageView()

    public let _seperator = UIView()

    public typealias ClickBlock = (_ v: ItemTitleContentView) -> Void

    public var _click: ClickBlock?
    
    public init(_ icon: UIImage? = nil, _ title: String = "标题", _ content: String = "", _ hint: String = "", _ style: Style = Style(), _ click: ClickBlock? = nil) {
        super.init(frame: CGRect.zero)

        configUI(icon != nil, style)

        if icon != nil {
            _icon.isHidden = false
            _icon.image = icon
        } else {
            _icon.isHidden = true
        }
        _content.text = content
        _content.attributedPlaceholder = NSAttributedString.init(string: hint, attributes: [NSAttributedString.Key.foregroundColor: style.placeholdColor])
        _content.clearButtonMode = .whileEditing
        _content.isSecureTextEntry = style.isSecureTextEntry
//        _content.numberOfLines = 0
        _title.text = title
        _arrow.image = UIImage(named: "list_arrow_gray")
        _arrow.isHidden = !(style.showArrow ?? (click != nil))
        _seperator.isHidden = !style.showSeperator
        _content.isEnabled = style.editabled
        _click = click
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(sender:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        makeConstraints(icon != nil, style)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func tapClick(sender: UIView) {
        _click?(self)
    }

    func configUI(_ showIcon: Bool = true, _ style: Style) {
        backgroundColor = color_white

        if showIcon {
            addSubview(_icon)
        }

        addSubview(_arrow)

        addSubview(_title)
        _title.font = UIFont.systemFont(ofSize: 16)
        _title.textColor = style.titleColor

        addSubview(_content)
        _content.font = UIFont.systemFont(ofSize: 16)
        _content.textColor = style.contentColor

        addSubview(_seperator)
        _seperator.backgroundColor = color_gray_EF
    }

    func makeConstraints(_ showIcon: Bool = true, _ style: Style) {
        if showIcon {
            _icon.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(15)
                $0.width.height.equalTo(20)
            }
        } else {
            _icon.snp.removeConstraints()
        }

        _arrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-15)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }

        _title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            if showIcon {
                $0.left.equalTo(_icon.snp.right).offset(15)
            } else {
                $0.leading.equalToSuperview().offset(15)
            }
            $0.trailing.equalTo(_arrow)
            $0.height.equalTo(22)
        }

        _content.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            if style.contentGravity == .left {
                $0.leading.equalToSuperview().offset(97)
            }

            if _arrow.isHidden {
                $0.right.equalToSuperview().offset(-15)
            } else {
                $0.right.equalTo(_arrow.snp.left).offset(-15)
            }
            $0.height.greaterThanOrEqualTo(22)
        }

        _seperator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(_title)
            $0.height.equalTo(0.5)
        }
    }
}
