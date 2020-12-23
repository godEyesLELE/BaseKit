//
//  WebImageExtension.swift
//  Liuxi
//
//  Created by wanghaipeng on 2020/4/22.
//  Copyright © 2020 whp. All rights reserved.
//

import Foundation
import Kingfisher

public typealias ProgressBlock = ((_ received: Int64, _ total: Int64) -> Void)
public typealias Finished = (() -> Void)
public typealias DownloadFinished = ((_ image: UIImage?) -> Void)
public typealias ErrorHandler = (() -> Void)

extension UIImageView {
    public func setImage(with url: String) {
        kf.setImage(with: URL(string: url))
    }
    public func setImage(with url: String, placeholder: UIImage?) {
        kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
    
    public func setImage(with url: String, placeholder: UIImage?, progressBlock: ProgressBlock?, completionHandler: Finished?) {
        kf.setImage(with: URL(string: url), placeholder: placeholder, options: nil, progressBlock: progressBlock) { (_, _, _, _) in
            if let completion = completionHandler {
                completion()
            }
        }
    }
    public func setImage(with url: String, placeholder: UIImage?, progressBlock: ProgressBlock?, completionHandler: Finished?, errorHandler: ErrorHandler?) {
        kf.setImage(with: URL(string: url), placeholder: placeholder, options: nil, progressBlock: progressBlock) { (image, _, _, _) in
            if image != nil {
                if let completion = completionHandler {
                    completion()
                }
            } else {
                if let errorHandler = errorHandler {
                    errorHandler()
                }
            }
        }
    }
    public func setImage(with url: String, lastName: String) {
        let placeholder = UIImage()
        setImage(with: url, placeholder: placeholder, progressBlock: nil, completionHandler: nil)
    }
    
    public func download(with url: String, progressBlock: ProgressBlock?, completionHandler: DownloadFinished?, errorHandler: ErrorHandler?) {
        kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: progressBlock) { (image, _, _, _) in
            if image != nil {
                if let completion = completionHandler {
                    completion(image)
                }
            } else {
                if let errorHandler = errorHandler {
                    errorHandler()
                }
            }
        }
    }
}
