//
//  DateTypeItemView.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/3.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

open class ItemGrowingContentView: UIView {
    public let _icon = UIImageView()

    public let _title = UILabel()

    public lazy var _content = RSKGrowingTextView() => { it in
        it.backgroundColor = color_white
        it.minimumNumberOfLines = 1
        it.maximumNumberOfLines = Int.max
        it.maxLenght = 500
        it.disableDoubleNewLine = true
        it.attributedPlaceholder = NSAttributedString(string: "提示",
                                                      attributes: [NSAttributedString.Key.foregroundColor: color_gray_B8, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        it.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        it.textColor = color_gray_22
        it.font = UIFont.systemFont(ofSize: 16)
    }

    public let _seperator = UIView()

    public typealias ClickBlock = () -> Void

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

        _content.attributedPlaceholder = NSAttributedString(string: hint,
                                                                attributes: [NSAttributedString.Key.foregroundColor: style.placeholdColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])

        _title.text = title
        _seperator.isHidden = !style.showSeperator
        _content.isEditable = style.editabled
        _click = click

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(sender:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        makeConstraints(icon != nil, style)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func tapClick(sender: UIView) {
        _click?()
    }

    func configUI(_ showIcon: Bool = true, _ style: Style) {
        backgroundColor = color_white

        if showIcon {
            addSubview(_icon)
        }

        addSubview(_title)
        _title.font = UIFont.systemFont(ofSize: 16)
        _title.textColor = style.titleColor

        addSubview(_content)

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

        _title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            if showIcon {
                $0.left.equalTo(_icon.snp.right).offset(15)
            } else {
                $0.leading.equalToSuperview().offset(15)
            }
            $0.height.equalTo(22)
        }

        _content.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            if style.contentGravity == .left {
                $0.leading.equalToSuperview().offset(97)
                $0.right.equalToSuperview().offset(-15)
            } else {
                $0.right.equalToSuperview().offset(-15)
            }
        }

        _seperator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(_title)
            $0.height.equalTo(0.5)
        }
    }
}
