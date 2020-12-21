//
// Created by chen on 2020/4/14.
// Copyright (c) 2020 MBC. All rights reserved.
//
import HandyJSON

open class BaseRequest: HandyJSON {
    public var httpMethod: String = "POST"

    public var appBuild: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    public var appCode: String = "102"
    public var sysType: String = "2"
    
    public var isDownload: Bool = false

    #if DEBUG
        public var appId = "a8a8068257864f44a90262f1386b6d60"
    #else
        public var appId = "82210f9a8f7849f1b21e804bc578b53d"
    #endif

    public required init() {
    }
}
