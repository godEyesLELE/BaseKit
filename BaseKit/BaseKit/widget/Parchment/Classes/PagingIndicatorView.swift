import UIKit

/// A custom `UICollectionViewReusableView` subclass used to display a
/// view that indicates the currently selected cell. You can subclass
/// this type if you need further customization; just override the
/// `indicatorClass` property in `PagingViewController`.
open class PagingIndicatorView: UICollectionReusableView {
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PagingIndicatorLayoutAttributes {
            backgroundColor = attributes.backgroundColor
            layer.cornerRadius = 1.5
            layer.masksToBounds = true
            
            frame = CGRect(origin: CGPoint(x: frame.origin.x + (frame.size.width - 35) / 2, y: frame.origin.y), size: CGSize(width: 35, height: frame.size.height))
//            frame.size.width = 40
        }
    }
}
