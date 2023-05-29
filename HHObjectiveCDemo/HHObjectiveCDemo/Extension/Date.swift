//
//  Date.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/26.
//

import Foundation

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

//明天
func nextDay() -> Date {
    return Date.init(timeIntervalSinceNow: 24*3600)
}
