//
//  ImagePickerCell.swift
//  Liuxi
//
//  Created by chen on 2020/4/29.
//  Copyright © 2020 whp. All rights reserved.
//

import UIKit

open class ImagePickerCell: UICollectionViewCell {
    public lazy var _image = UIImageView() => { it in
        self.contentView.addSubview(it)
        it.backgroundColor = color_gray_F5
        it.clipsToBounds = true
        it.image = UIImage(named: "add_img_icon")
        it.contentMode = .center
        it.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
    }

    public lazy var _delete = UIButton() => { it in
        self.contentView.addSubview(it)
        it.setImage(UIImage(named: "photo_delete"), for: .normal)
        it.snp.makeConstraints {
            $0.width.height.equalTo(18)
            $0.top.right.equalTo(self._image)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init() {
        super.init(frame: CGRect.zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
