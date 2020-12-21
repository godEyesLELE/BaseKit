//
// Created by chen on 2020/4/15.
// Copyright (c) 2020 MBC. All rights reserved.
//

import HandyJSON
import RxAlamofire
import RxSwift
import UIKit

open class ViewModel {
    public required init() {
    }

    open lazy var disposeBag: DisposeBag = DisposeBag()

    open func load<R>(_ ob: Observable<BaseResponse<R>>, _ suc: @escaping (BaseResponse<R>) -> Void, _ fail: ((BaseResponse<R>) -> Void)? = nil) {
        ob.subscribe(onNext: { $0.suc() ? suc($0) : fail?($0) })
            .disposed(by: disposeBag)
    }
}
