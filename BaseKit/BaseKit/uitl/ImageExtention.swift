//
//  ImageExtention.swift
//  BaseKit
//
//  Created by chen on 2020/4/23.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
extension UIImage {
    open class func dm_image(withImageLight light: UIImage, dark: UIImage) -> UIImage {
        UIImage() => { it in
            it.imageAsset?.register(light, with: UITraitCollection(userInterfaceStyle: .light))
            it.imageAsset?.register(dark, with: UITraitCollection(userInterfaceStyle: .dark))
        }
    }
}
