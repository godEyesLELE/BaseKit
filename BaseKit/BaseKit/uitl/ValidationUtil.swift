//
//  ValidationUtil.swift
//  BaseKit
//
//  Created by chen on 2020/6/2.
//  Copyright © 2020 chen. All rights reserved.
//

import Foundation

let REGEX_PASSWORD = "^(?![\\x30-\\x39]+$)(?![\\x21-\\x2F\\x3A-\\x40\\x5B-\\x60\\x7B-\\x7E]+$)(?![\\x41-\\x5A\\x61-\\x7A]+$)[\\x21-\\x7E]{8,16}$";

public class ValidationUtil {
    
    
    public class func checkPwd(_ pwd:String) -> Bool{
    
        if try! NSRegularExpression(pattern: REGEX_PASSWORD, options: []).matches(in: pwd, options: [], range: NSRange(location: 0, length: pwd.count)).count > 0 {
            return true
        }
        
        return false
    }
}
