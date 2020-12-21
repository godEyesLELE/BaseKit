//
//  BaseRefresh.swift
//  Liuxi
//
//  Created by  yc_htl on 2020/12/11.
//  Copyright © 2020 whp. All rights reserved.
//

import Foundation
import MJRefresh
//extension MJRefreshStateHeader{
//    open override func placeSubviews() {
//        super.placeSubviews()
//
//    }
//}

open class baseHeader: MJRefreshNormalHeader {
    open override func prepare() {
        super.prepare()
        self.lastUpdatedTimeLabel?.isHidden = true
        self.arrowView?.image = nil
        self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
}

open class baseAutoFooter: MJRefreshAutoNormalFooter {
    open override func prepare() {
        super.prepare()
        self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
    }
}

open class baseFotter: MJRefreshBackNormalFooter {
    open override func prepare() {
        super.prepare()
        self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
        self.arrowView?.image = nil
    }
}


public extension UIScrollView {
    
    
    /// 添加头部刷新事件
    ///
    /// - Parameter refreshClosure: 闭包回调
    func addRefreshHeaderWithScrollView(refreshClosure:@escaping(() -> ())) {
        let header = baseHeader.init {
            refreshClosure()
        }
        header.isAutomaticallyChangeAlpha = true
        header.setTitle("下拉刷新", for: MJRefreshState.idle)
        header.setTitle("松开立即刷新", for:MJRefreshState.pulling)
        header.setTitle("正在刷新", for: MJRefreshState.refreshing)
        self.mj_header = header
    }
    
    /// 下拉加载
    ///
    /// - Parameters:
    ///   -  tableView: tableView
    ///   - refreshClosure: 闭包回调
    func addRefreshAutoFooterWithScrollView(refreshClosure:@escaping()->()) {
        let foot:MJRefreshAutoNormalFooter = baseAutoFooter.init {
            refreshClosure()
        }
//        foot.isAutomaticallyHidden = true
        
        self.mj_footer = foot
    }
    
    func addRefreshFooterWithScrollView(refreshClosure:@escaping()->()) {
        let foot:MJRefreshBackNormalFooter = baseFotter.init {
            refreshClosure()
        }
        self.mj_footer = foot
        
    }
    
    /// 结束刷新
    ///
    /// - Parameter tableView: tableView
    func endRefreshWithTableView() {
        /*
        if let header = mj_header {
            
        } else {
            
        }
        guard let header = mj_header else {
            // 一定为空 mjheader == nil
            return
        }
         */
        self.mj_header?.endRefreshing()
        self.mj_footer?.endRefreshing()
        
    }
    
    func ignoreFooter(ignoreFooter:Bool = false)  {
        self.mj_footer?.isHidden = ignoreFooter
    }
    
    
    /// 没有数据
    func noMoreData() {
        self.endRefreshWithTableView()
        self.mj_footer?.state = .noMoreData
    }
    
    func removeRefreshHeader() {
        self.mj_header?.endRefreshing()
        self.mj_header = nil
        
    }
    
    func removeRefreshFooter() {
        self.mj_footer?.endRefreshing()
        self.mj_footer = nil
    }
    
}
