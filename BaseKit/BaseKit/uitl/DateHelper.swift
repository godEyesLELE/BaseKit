//
//  DateHelper.swift
//  BaseKit
//
//  Created by chen on 2020/9/16.
//  Copyright © 2020 chen. All rights reserved.
//

public let FORMATTER_yMd_Hms = "yyyy-MM-dd HH:mm:ss"
public let FORMATTER_yMd_Hm = "yyyy-MM-dd HH:mm"
public let FORMATTER_Md_Hm = "MM-dd HH:mm"
public let FORMATTER_yMd = "yyyy-MM-dd"
public let FORMATTER_Md = "MM-dd"
public let FORMATTER_Hms = "HH:mm:ss"
public let FORMATTER_Hm = "HH:mm"
public let FORMATTER_H = "HH"
public let FORMATTER_m = "mm"

open class DateHelper {
    
    public class func timeStampConvertString(timeStamp: TimeInterval, dateFormat: String = FORMATTER_yMd) -> String {
        let  timeInterval: TimeInterval  =  TimeInterval (timeStamp)
        let  date =  NSDate (timeIntervalSince1970: timeInterval)
        return dateConvertString(date: date as Date, dateFormat: dateFormat)
    }
    
    public class func stringConvertDate(dateString: String?, dateFormat: String = FORMATTER_yMd_Hms) -> Date? {
        guard let dateString = dateString else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    public static func dateConvertString(date: Date, dateFormat: String = FORMATTER_yMd) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    public static func stringConvertString(dateString: String?, dateFormat: String = FORMATTER_yMd_Hms, dateFormatOutput : String = FORMATTER_yMd_Hms) -> String? {
        guard let date = stringConvertDate(dateString: dateString, dateFormat: dateFormat) else {
            return nil
        }
        return dateConvertString(date: date, dateFormat: dateFormatOutput)
    }
    
    public static func friendlyDate(dateString: String?, dateFormat: String = FORMATTER_yMd_Hms) -> String? {
        guard let _dateString = dateString else { return nil }
        guard let date = stringConvertDate(dateString: _dateString, dateFormat: dateFormat) else { return nil }
        return friendlyDate(date: date)
    }
    
    public static func friendlyDate(date: Date) -> String {
        var dateFormat = FORMATTER_yMd_Hm
        
        let calendar = Calendar.current
        
        let currentDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let fromDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let yearDiff = currentDate.year! - fromDate.year!
        let monthDiff = currentDate.month! - fromDate.month!
        let dayDiff = currentDate.day! - fromDate.day!
        let hourDiff = currentDate.hour! - fromDate.hour!
        let minuteDiff = currentDate.minute! - fromDate.minute!
        
        if  yearDiff < 1 && monthDiff < 1{
            if dayDiff < 1 {
                if hourDiff < 1 {
                    if minuteDiff < 0 {
                        return "\(60+minuteDiff)分钟前"
                    } else if minuteDiff == 0 {
                        return "刚刚"
                    }
                    return "\(minuteDiff)分钟前"
                } else {
                    dateFormat =  FORMATTER_Hm
                }
            }else if dayDiff < 2 {
                dateFormat =  "昨天 \(FORMATTER_Hm)"
            }else if dayDiff < 3 {
                dateFormat =  "前天 \(FORMATTER_Hm)"
            }else {
                dateFormat = FORMATTER_Md_Hm
            }
        }else if  yearDiff < 1 {
            dateFormat = FORMATTER_Md_Hm
        }
        return dateConvertString(date: date, dateFormat: dateFormat)
    }
    
    public static func getWeek(date: Date) -> String {

        let weekDay = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        
        return weekDay[Calendar.current.dateComponents([.weekday], from: date).weekday! - 1]

    }
    
    //两个日期相差几分钟
    public static func diffMinute(early:Date, late:Date) -> Int{
        return Calendar.current.dateComponents([.minute], from: early, to: late).minute ?? 0
    }
    
    //两个日期相差几天
    public static func diffDay(d1:Date, d2:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: d1, to: d2).day ?? 0
    }
    //几天 几月 几年 后
    public static func dateStringAfter(day: Int, month: Int = 0, year: Int = 0, date: Date = Date(), dateFormat: String = FORMATTER_yMd_Hms) -> String {
        return dateConvertString(date: dateAfter(day: day, month: month, year: year, date:  date), dateFormat: dateFormat)
    }
    //几天 几月 几年 后
    public static func dateAfter(day: Int, month: Int = 0, year: Int = 0, date: Date = Date()) -> Date {
    
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        return Calendar.current.date(byAdding: comps, to: date)!
    }
    
    public static func betweenDate(curDate: Date = Date(),start: Date, end: Date) -> Bool {
        (curDate.compare(start) == .orderedDescending && curDate.compare(end) == .orderedAscending)
    }
}

extension Date {
    
    func formatTo(formatter:String = FORMATTER_yMd_Hms) -> String {
        DateHelper.dateConvertString(date: self, dateFormat: formatter)
    }
}
