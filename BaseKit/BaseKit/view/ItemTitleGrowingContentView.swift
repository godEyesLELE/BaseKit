//
//  DateTypeItemView.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/3.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

open class ItemTitleGrowingContentView: UIView {
    public let _icon = UIImageView()

    public let _title = UILabel()

    public lazy var _content = NextGrowingTextView() => { it in
        it.backgroundColor = color_white
        it.minNumberOfLines = 1
        it.maxNumberOfLines = 5
        it.textDidChange = { [weak self] _ in
            
        }
        it.showsVerticalScrollIndicator = false
        it.showsHorizontalScrollIndicator = false
        it.placeholderAttributedText = NSAttributedString(string: "提示",
                                                          attributes: [NSAttributedString.Key.foregroundColor: color_gray_B8, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        it.textView.textContainerInset = .init(top: 2, left: 0, bottom: 0, right: 0)
        it.textView.textColor = color_gray_22
        it.textView.font = UIFont.systemFont(ofSize: 16)
    }

    public let _seperator = UIView()

    public typealias ClickBlock = (_ v: ItemTitleGrowingContentView) -> Void

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

        _content.textView.text = content
        
        _content.placeholderAttributedText = NSAttributedString(string: hint,
                                                          attributes: [NSAttributedString.Key.foregroundColor: style.placeholdColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
       
//        _content.numberOfLines = 0
        _title.text = title
        _seperator.isHidden = !style.showSeperator
        _content.textView.isEditable = style.editabled
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
        _click?(self)
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
