//
//  Date.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/26.
//

import Foundation

//"2023-07-20 10:22:59.000" 对应的dateFormat："yyyy-MM-dd HH:mm:ss.SSS"
func stringToDate(string: String) -> Date? {
    // 创建一个 DateFormatter 对象来格式化日期字符串
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.date(from: string)
}

func dateToString(date: Date) -> String {
    // 创建一个 DateFormatter 对象来格式化日期字符串
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

// MARK: 当前时间
func currentDateTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: Date())
}

// MARK: 明天
func nextDay() -> Date {
    return Date.init(timeIntervalSinceNow: 24*3600)
}

// MARK: 计算两个日期之间的天数差异，您可以使用 Swift 的 Calendar 和 DateComponents
func datedays(string: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

    if let endDate = dateFormatter.date(from: string) {
        let calendar = Calendar.current

        let startDate = Date()
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let days = components.day {
            print("Days between the two dates: \(days)")
            return days
        }
    }
    return 9999
}
