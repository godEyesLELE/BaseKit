//
//  DateTypeItemView.swift
//  mbc_jrcxpt
//
//  Created by chen on 2020/3/3.
//  Copyright © 2020 MBC. All rights reserved.
//

import UIKit

open class ItemTitleImagesView: UIView {
    let _seperator = UIView()

    var imageUrlArr = [String]()

    lazy var _picCollection: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = color_white
        cv.isScrollEnabled = false
        cv.register(ImagePickerCell.self)
        return cv
    }()

    public init() {
        super.init(frame: CGRect.zero)

        configUI()

        makeConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setData(_ images: Array<String>) {
        imageUrlArr.removeAll()
        imageUrlArr += images
        _picCollection.reloadData()
    }

    func configUI() {
        backgroundColor = color_white

        addSubview(_picCollection)

        addSubview(_seperator)
        _seperator.backgroundColor = color_gray_EF
    }

    func makeConstraints() {
        _picCollection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
            $0.leading.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.greaterThanOrEqualTo(80)
        }

        _seperator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(_picCollection)
            $0.height.equalTo(0.5)
        }
    }
}

extension ItemTitleImagesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageUrlArr.count >= 4 {
            return 4
        }
        return imageUrlArr.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, type: ImagePickerCell.self)
        if imageUrlArr.count > indexPath.row {
            cell._image.setImage(with: imageUrlArr[indexPath.row])
            cell._delete.isHidden = false
        } else {
            cell._image.image = UIImage(named: "add_img_icon")
            cell._delete.isHidden = true
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
    }

    // 定义每个UICollectionViewCell 的大小
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }

    // 每个section中不同的行之间的行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    // 每个item之间的间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let brower = XLPhotoBrowser.show(withImages: imageUrlArr, currentImageIndex: indexPath.item)
//        brower?.browserStyle = .simple
        // to show
    }
}

