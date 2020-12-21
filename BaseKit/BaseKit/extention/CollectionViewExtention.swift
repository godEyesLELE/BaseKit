//
//  CollectionViewExtention.swift
//  BaseKit
//
//  Created by chen on 2020/4/29.
//  Copyright © 2020 chen. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, type: T.Type) -> T {
        let name = String(describing: type)
        let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as! T
        
        return cell
    }

    public func register<T: UICollectionViewCell>(_ type: T.Type) {
        let name = String(describing: type)
        register(type, forCellWithReuseIdentifier: name)
    }

    public func registerNib<T: UICollectionViewCell>(_ type: T.Type) {
        let name = String(describing: type)
        register(UINib(nibName: name, bundle: Bundle(for: type)), forCellWithReuseIdentifier: name)
    }
    
    public func registerHeaderFoot<T: UICollectionReusableView>(_ type: T.Type, kind: String) {
        let name = String(describing: type)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
    }
    public func dequeueReusableHeaderFooter<T: UICollectionReusableView>(type: T.Type, kind: String, indexPath: IndexPath) -> T {
        let name = String(describing: type)
        let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: name, for: indexPath)
        return view as! T
    }
}
