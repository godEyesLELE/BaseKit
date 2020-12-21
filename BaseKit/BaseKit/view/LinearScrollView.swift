//
//  JJLinearScrollView.swift
//  JJLinearScrollView
//
//  Created by  HanJinJun on 2017/8/26.
//  Copyright © 2017年  HanJinJun. All rights reserved.
//

import SnapKit
import UIKit

/// 滚动方向
///
/// - vertical: 垂直方向
/// - horizontal: 水平方向
public enum LinearScrollOrientation {
    /// 垂直方向
    case vertical
    /// 水平方向
    case horizontal
}

open class LinearSubView {
    public var view: UIView
    public var insets: UIEdgeInsets
    public var height: CGFloat
    public var center: Bool

    public init(view: UIView, insets: UIEdgeInsets, height: CGFloat, center: Bool = false) {
        self.view = view
        self.insets = insets
        self.height = height
        self.center = center
    }
}

open class LinearScrollView: UIScrollView {
    /// 滚动方向
    open var orientation: LinearScrollOrientation = .vertical {
        didSet {
            updateLayout()
        }
    }

    /// 内边距
    public var inset = UIEdgeInsets.zero {
        didSet {
            linearContentView.snp.updateConstraints { make in
                make.edges.equalTo(self).inset(inset)
            }
        }
    }

    /// 各个控件的间距
    @IBInspectable var spacing: CGFloat = 0.0
    /// 子控件
    fileprivate var arrangedSubviews = Array<LinearSubView>()

    /// 内容视图
    lazy var linearContentView = UIView()

    // MARK: 初始化

    public init(frame: CGRect, orientation: LinearScrollOrientation) {
        super.init(frame: frame)
        self.orientation = orientation
        setupUI()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    public convenience init(orientation: LinearScrollOrientation) {
        self.init(frame: CGRect.zero, orientation: orientation)
    }

    public convenience init() {
        self.init(frame: CGRect.zero, orientation: .vertical)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: 初始化UI

    func setupUI() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        // 设置内容视图布局
        addSubview(linearContentView)
        linearContentView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(self.inset)

            if self.orientation == .vertical {
                make.width.equalTo(self)
            } else {
                make.height.equalTo(self)
            }
        }
    }

    // MARK: 追加

    /// 添加子控件，线性布局
    ///
    /// - Parameter view: 子控件
    open override func addSubview(_ view: UIView) {
        addArrangedSubview(view, insets: UIEdgeInsets.zero, height: 0)
    }

    // MARK: 追加

    /// 添加子控件，线性布局
    ///
    /// - Parameter view: 子控件
    public func addSubviewBatch(_ views: UIView...) {
        guard views.count > 0 else { return }
        arrangedSubviews += views.map {
            linearContentView.addSubview($0)
            return LinearSubView(view: $0, insets: UIEdgeInsets.zero, height: 0)
        }
        updateViewHeight(views[0], -1)
    }

    /// 添加子控件，线性布局
    ///
    /// - Parameters:
    ///   - view: 子控件
    ///   - insets: 子控件的边距
    ///   - height: 子控件的高度，不传默认自动高度
    public func addArrangedSubview(_ view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero, height: CGFloat = 0.0, center: Bool = false) {
        if view == linearContentView {
            super.addSubview(view)
            return
        }
        linearContentView.addSubview(view)
        let subView = LinearSubView(view: view, insets: insets, height: height, center: center)
        layoutSubview(subView, preSubView: arrangedSubviews.last)
        arrangedSubviews.append(subView)
    }

    // MARK: Insert 插入

    open override func insertSubview(_ view: UIView, at index: Int) {
        insertArrangedSubview(view, at: index)
    }

    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        insertSubview(view, aboveSubview: siblingSubview)
    }

    open override func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        insertSubview(view, belowSubview: siblingSubview)
    }

    /// 插入子控件
    ///
    /// - Parameters:
    ///   - view: 子控件
    ///   - siblingSubview: 在其他的子控件上面
    ///   - insets: 边距
    ///   - height: 高度
    public func insertArrangedSubview(_ view: UIView, aboveSubview siblingSubview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero, height: CGFloat = 0.0) {
        let index = self.index(view)
        if index != nil {
            insertArrangedSubview(view, at: index!, insets: insets, height: height)
        }
    }

    /// 插入子控件
    ///
    /// - Parameters:
    ///   - view: 子控件
    ///   - siblingSubview: 在其他的子控件下面
    ///   - insets: 边距
    ///   - height: 高度,default:0 自动高度
    public func insertArrangedSubview(_ view: UIView, belowSubview siblingSubview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero, height: CGFloat = 0.0) {
        let index = self.index(view)
        if index != nil {
            insertArrangedSubview(view, at: index! + 1, insets: insets, height: height)
        }
    }

    /// 插入子控件
    ///
    /// - Parameters:
    ///   - view: 子控件
    ///   - index: 位置
    ///   - insets: 边距
    ///   - height: 高度,default:0 自动高度
    public func insertArrangedSubview(_ view: UIView, at index: Int, insets: UIEdgeInsets = UIEdgeInsets.zero, height: CGFloat = 0.0) {
        // 如果插入的地方在末尾，直接调用追加的方法
        if index >= arrangedSubviews.count {
            addArrangedSubview(view, insets: insets, height: height)
            return
        }

        // 获取前一个SubView
        var preSubView: LinearSubView?
        if index > 0 {
            preSubView = arrangedSubviews[index - 1]
        }

        // 获取后一个SubView
        var sufSubView: LinearSubView?
        if index < arrangedSubviews.count {
            sufSubView = arrangedSubviews[index]
        }

        linearContentView.addSubview(view)
        let subView = LinearSubView(view: view, insets: insets, height: height)
        layoutSubview(subView, preSubView: preSubView, sufSubView: sufSubView)
        arrangedSubviews.append(subView)
    }

    // MARK: Remove 移除

    /// 移除子控件
    ///
    /// - Parameter view: 要被移除的控件
    public func removeArrangedSubview(_ view: UIView) {
        let index = self.index(view)
        guard index != nil else {
            print("该View不存在于队列中，无需移除")
            return
        }
        removeArrangedSubView(at: index!)
    }

    /// 移除子控件
    ///
    /// - Parameter index: 位置
    public func removeArrangedSubView(at index: Int) {
        arrangedSubviews[index].view.removeFromSuperview()
        arrangedSubviews.remove(at: index)
        var preSubView: LinearSubView?
        if index > 0 {
            preSubView = arrangedSubviews[index - 1]
        }
        // 重新布局
        if index == arrangedSubviews.count {
            // whp: 移除最后一个有bug
        } else {
            layoutSubview(arrangedSubviews[index], preSubView: preSubView)
        }
    }

    // MARK: 布局子控件

    private func layoutSubview(_ subView: LinearSubView, preSubView: LinearSubView?, sufSubView: LinearSubView? = nil) {
        switch orientation {
        case .vertical:
            layoutVerticalSubview(subView, preSubView: preSubView)
            break
        case .horizontal:
            layoutHorizontalSubview(subView, preSubView: preSubView)
            break
        }
        if sufSubView != nil {
            layoutSubview(sufSubView!, preSubView: subView)
        }
    }

    private func layoutVerticalSubview(_ subView: LinearSubView, preSubView: LinearSubView?) {
        subView.view.snp.remakeConstraints { make in
            if subView.center {
                make.centerX.equalTo(self.linearContentView)
                make.width.equalTo(subView.view.snp_width)
            } else {
                make.left.equalTo(self.linearContentView).offset(subView.insets.left)
                make.right.equalTo(self.linearContentView).offset(-subView.insets.right)
            }
            make.top.greaterThanOrEqualTo(self.linearContentView).offset(subView.insets.top)
            make.bottom.lessThanOrEqualTo(self.linearContentView).offset(-subView.insets.bottom)

            if preSubView != nil {
                make.top.equalTo(preSubView!.view.snp.bottom).offset(subView.insets.top + preSubView!.insets.bottom + self.spacing)
            }

            if subView.view.isHidden {
                make.height.equalTo(0)
            } else {
                if subView.height > 0 {
                    make.height.equalTo(subView.height)
                }
            }
        }
    }

    private func layoutHorizontalSubview(_ subView: LinearSubView, preSubView: LinearSubView?) {
        subView.view.snp.remakeConstraints { make in
            make.left.greaterThanOrEqualTo(self.linearContentView).offset(subView.insets.left)
            make.top.equalTo(self.linearContentView).offset(subView.insets.top)
            make.right.lessThanOrEqualTo(self.linearContentView).offset(-subView.insets.right)
            make.bottom.equalTo(self.linearContentView).offset(-subView.insets.bottom)

            if preSubView != nil {
                make.left.equalTo(preSubView!.view.snp.right).offset(subView.insets.left + preSubView!.insets.right + self.spacing)
            }

            if subView.view.isHidden {
                make.height.equalTo(0)
            } else {
                if subView.height > 0 {
                    make.height.equalTo(subView.height)
                }
            }
        }
    }

    /// 更新布局
    func updateLayout() {
        linearContentView.snp.remakeConstraints { make in
            make.edges.equalTo(self).inset(self.inset)

            if self.orientation == .vertical {
                make.width.equalTo(self)
            } else {
                make.height.equalTo(self)
            }
        }

        var lastSubView: LinearSubView?
        for subView in arrangedSubviews {
            layoutSubview(subView, preSubView: lastSubView)
            lastSubView = subView
        }
    }

    public func updateViewHeight(_ view: UIView, _ height: CGFloat) {
        guard let index = arrangedSubviews.firstIndex(where: { $0.view == view }) else { return }

        if height >= 0 {
            arrangedSubviews[index].height = height
        }

        var preSubView: LinearSubView? = index > 0 ? arrangedSubviews[index - 1] : nil

        for subView in arrangedSubviews.suffix(from: index) {
            layoutSubview(subView, preSubView: preSubView)
            preSubView = subView
        }
    }

    public func hideSubview(_ view: UIView, _ isHidden: Bool = true) {
        view.isHidden = isHidden
        updateViewHeight(view, -1)
    }

    /// 查找View的位置
    public func index(_ view: UIView) -> Int? {
        return arrangedSubviews.firstIndex(where: { $0.view == view })
    }
}
