//
//  NetError.swift
//  BaseKit
//
//  Created by chen on 2020/6/5.
//  Copyright © 2020 chen. All rights reserved.
//

import Foundation

open class NetError: Error {
    public var status: Int
    public var msg: String

    public init(_ status: Int, _ msg: String) {
        self.status = status
        self.msg = msg
    }
}
