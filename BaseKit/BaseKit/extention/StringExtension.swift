//
//  StringExtension.swift
//  BaseKit
//
//  Created by chen on 2020/4/30.
//  Copyright © 2020 chen. All rights reserved.
//

extension String {
    public var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    public var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public func formatDate(dateFormat: String = "yyyy-MM-dd") -> String {
        return DateUtil.dateConvertString(date: DateUtil.stringConvertDate(string: self), dateFormat: dateFormat)
    }
}
