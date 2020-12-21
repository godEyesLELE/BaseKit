//
// Created by chen on 2020/4/14.
// Copyright (c) 2020 MBC. All rights reserved.
//

import HandyJSON

open class BaseResponse<K>: HandyJSON {
    public var data: K? = nil
    public var status: Int = 300
    public var message: String = ""
    
    public var fromCache = false

    public required init() {

    }
    
    convenience public init (data: K? = nil, status: Int = 300, message: String = "") {
        self.init()
        self.data = data
        self.status = status
        self.message = message
    }
    
    public func suc() -> Bool {
        200..<300 ~= status
    }
}
