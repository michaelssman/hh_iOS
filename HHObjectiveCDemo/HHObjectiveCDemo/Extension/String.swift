//
//  String.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/5/30.
//

import Foundation

extension String {
    func paddedNumber() -> String {
        let number = 5
        let paddedNumber = String(format: "%02d", number)
        print(paddedNumber) // 输出 "05"
        return paddedNumber
    }
    func stringToInt() -> Int{
        let str = "5"
        let number: Int = Int(str) ?? 0
        return number
    }
}
