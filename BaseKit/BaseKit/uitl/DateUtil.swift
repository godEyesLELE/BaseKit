//
//  DateUtil.swift
//  BaseKit
//
//  Created by chen on 2020/5/6.
//  Copyright © 2020 chen. All rights reserved.
//

open class DateUtil {
    
    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
    public static func stringConvertDate(string: String?, dateFormat: String = "yyyy-MM-dd HH:mm:ss", abbreviation: String = "UTC") -> Date {
        if string?.isEmpty ?? true { return Date() }

        let timeZone = TimeZone(abbreviation: abbreviation)!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: string!) ?? Date()
    }
    
    public static func stringConvertString(string: String?, dateFormat: String = "yyyy-MM-dd HH:mm:ss", abbreviation: String = "UTC", dateOutput : String = "yyyy-MM-dd HH:mm:ss") -> String? {
        if string?.isEmpty ?? true { return nil }

        let timeZone = TimeZone(abbreviation: abbreviation)!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: string!)
        if date == nil { return nil }
        
        return dateConvertString(date: date!, dateFormat: dateOutput, abbreviation: abbreviation)
    }
    /// Date类型转化为日期字符串
    ///
    /// - Parameters:
    ///   - date: Date类型
    ///   - dateFormat: 格式化样式默认“yyyy-MM-dd”
    /// - Returns: 日期字符串
    public static func dateConvertString(date: Date, dateFormat: String = "yyyy-MM-dd", abbreviation: String = "UTC") -> String {
        let timeZone = TimeZone(abbreviation: abbreviation)!
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /// 服务器返回零时区,需要转回东8再用
    public static func utcDateCovertLocalDate(date: Date) -> Date {
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localDate = date.addingTimeInterval(TimeInterval(interval))
        return localDate
    }

    /// Date类型转化为日期字符串
    ///
    /// - Parameters:
    ///   - date: Date类型
    ///   - dateFormat: 格式化样式默认“yyyy-MM-dd”
    /// - Returns: 日期字符串
//    public static func dateAfter(day: Int, month: Int = 0, year: Int = 0, date: Date = Date(), dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
//        let calendar = Calendar.current
//        var comps: DateComponents?
//
//        comps = calendar.dateComponents([.year, .month, .day], from: date)
//        comps?.year = year
//        comps?.month = month
//        comps?.day = day
//        let result = calendar.date(byAdding: comps!, to: date) ?? Date()
//
//        return dateConvertString(date: result, dateFormat: dateFormat)
//    }

    public static func friendlyDate(date: Date) -> String {
        let nowDate = NSDate()
        let timeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        if calendar.isDateInToday(date) {
            return dateConvertString(date: date, dateFormat: "HH:mm")
        }
        if calendar.isDateInYesterday(date) {
            return dateConvertString(date: date, dateFormat: "昨天 HH:mm")
        }

        let gap = calendar.dateComponents([Calendar.Component.year, Calendar.Component.day], from: date, to: nowDate as Date)

        if gap.year! < 1 {
            if gap.day! == 0 {
                return dateConvertString(date: date, dateFormat: "HH:mm")
            }
            if gap.day! < 1 {
                return dateConvertString(date: date, dateFormat: "昨天 HH:mm")
            }
            if gap.day! < 2 {
                return dateConvertString(date: date, dateFormat: "前天 HH:mm")
            }
            return dateConvertString(date: date, dateFormat: "MM-dd HH:mm")
        }
        return dateConvertString(date: date, dateFormat: "yyyy-MM-dd HH:mm")
    }

    public static func getWeek(date: Date) -> String {

        let weekDay = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        
        let calendar = Calendar.current
        var comps: DateComponents?

        comps = calendar.dateComponents([.weekday], from: date)
        return weekDay[comps!.weekday! - 1]

    }
    
    // 获取上一个月份(年份)
    public static func getLastMonth(date: Date) -> Date? {
        let timeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
        var componen = calendar.dateComponents([.year, .month, .day], from: date)
        componen.month! -= 1
        let lastMonthDate = calendar.date(from: componen)
        return lastMonthDate
    }
    
    //指定年月的开始日期
    public static func startOfMonth(date: Date) -> Date {
        let timeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        let startDate = calendar.date(from: startComps)!
        return startDate
    }
     
    //指定年月的结束日期
    public static func endOfMonth(date: Date, returnEndTime:Bool = false) -> Date {
        let timeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
         
        let endOfYear = calendar.date(byAdding: components,
                                      to: startOfMonth(date: date))!
        return endOfYear
    }
    
    public static func diffMinute(early:Date, late:Date) -> Int{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal.dateComponents([.minute], from: early, to: late).minute ?? 0
    }
    
    public static func diffDay(d1:Date, d2:Date) -> Int{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal.dateComponents([.day], from: d1, to: d2).day ?? 0
    }
    
}
