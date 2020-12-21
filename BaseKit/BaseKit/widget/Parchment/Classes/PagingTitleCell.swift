import SnapKit
import UIKit

/// A custom `PagingCell` implementation that only displays a text
/// label. The title is based on the `PagingTitleItem` and the colors
/// are based on the `PagingTheme` passed into `setPagingItem:`. When
/// applying layout attributes it will interpolate between the default
/// and selected text color based on the `progress` property.
open class PagingTitleCell: PagingCell {
    public let titleLabel = UILabel(frame: .zero)
    private var viewModel: PagingTitleCellViewModel?

    private lazy var horizontalConstraints: [NSLayoutConstraint] = {
        NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[label]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["label": titleLabel])
    }()

    private lazy var verticalConstraints: [NSLayoutConstraint] = {
        NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[label]|",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: ["label": titleLabel])
    }()

    lazy var _redPoint = MLinView(mWidth: .wrap, mHeight: .wrap) => { it in
        
        let lb = UILabel(mWidth: .wrap, mHeight: .wrap) => { text in
            text.font = UIFont.systemFont(ofSize: 12)
            text.textColor = color_white_text
            text.mLeft = 5
            text.mRight = 5
        }
        
        it.addSubview(lb)
        
        it.layer.cornerRadius = 8
        it.layer.masksToBounds = true
        it.backgroundColor = color_red
        it.isHidden = true
        
    }

    open override var isSelected: Bool {
        didSet {
            configureTitleLabel()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    public func setRedPoint(_ count:Int) {

        _redPoint.isHidden = count <= 0
        
        _redPoint.child(0, UILabel.self)?.text = "\(count)"
    }

    open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, options: PagingOptions) {
        if let titleItem = pagingItem as? PagingIndexItem {
            viewModel = PagingTitleCellViewModel(
                title: titleItem.title,
                selected: selected,
                options: options)
        }
        configureTitleLabel()
        configureAccessibility()
    }

    open func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(_redPoint)
        contentView.isAccessibilityElement = true
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        _redPoint.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(4)
        }
    }

    open func configureTitleLabel() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        titleLabel.textAlignment = .center

        if viewModel.selected {
            titleLabel.font = viewModel.selectedFont
            titleLabel.textColor = viewModel.selectedTextColor
            backgroundColor = viewModel.selectedBackgroundColor
        } else {
            titleLabel.font = viewModel.font
            titleLabel.textColor = viewModel.textColor
            backgroundColor = viewModel.backgroundColor
        }

        horizontalConstraints.forEach { $0.constant = viewModel.labelSpacing }
    }

    open func configureAccessibility() {
        accessibilityIdentifier = viewModel?.title
        contentView.accessibilityLabel = viewModel?.title
        contentView.accessibilityTraits = viewModel?.selected ?? false ? .selected : .none
    }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let viewModel = viewModel else { return }
        if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
            titleLabel.textColor = UIColor.interpolate(
                from: viewModel.textColor,
                to: viewModel.selectedTextColor,
                with: attributes.progress)

            backgroundColor = UIColor.interpolate(
                from: viewModel.backgroundColor,
                to: viewModel.selectedBackgroundColor,
                with: attributes.progress)
        }
    }
}
