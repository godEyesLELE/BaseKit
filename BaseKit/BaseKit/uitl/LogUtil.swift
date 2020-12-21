//
//  LogUtil.swift
//  BaseKit
//
//  Created by chen on 2020/4/22.
//  Copyright © 2020 chen. All rights reserved.
//

public func Log(_ s: String) {
    print(s.jsonFormatPrint())
}

extension String {
    func jsonFormatPrint() -> NSString {
        if starts(with: "{") || starts(with: "[") {
            var level = 0
            var jsonFormatString = String()

            func getLevelStr(level: Int) -> String {
                var string = ""
                for _ in 0 ..< level {
                    string.append("\t")
                }
                return string
            }

            for char in self {
                if level > 0 && "\n" == jsonFormatString.last {
                    jsonFormatString.append(getLevelStr(level: level))
                }

                switch char {
                case "{":
                    fallthrough
                case "[":
                    level += 1
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case ",":
                    jsonFormatString.append(char)
                    jsonFormatString.append("\n")
                case "}":
                    fallthrough
                case "]":
                    level -= 1
                    jsonFormatString.append("\n")
                    jsonFormatString.append(getLevelStr(level: level))
                    jsonFormatString.append(char)
                    break
                default:
                    jsonFormatString.append(char)
                }
            }
            return jsonFormatString as NSString
        }

        return self as NSString
    }
}
