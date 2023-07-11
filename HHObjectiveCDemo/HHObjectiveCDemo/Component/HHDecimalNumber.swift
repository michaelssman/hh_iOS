//
//  HHDecimalNumber.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/7/7.
//

import UIKit
import Foundation

class HHDecimalNumber: NSObject {
    // 保持小数位，不足可以补小数点或者0.
    @objc static func returnDecimalDigitsFormatter(_ value: NSString, decimalDigits: Int16, autoAddZero: Bool) -> String {
        // 小数位为0，保留整数
        if decimalDigits == 0 {
            return String(value.intValue)
        }
        // 四舍五入，保留小数
        let decimalNumberHandler: NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: decimalDigits, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let aDN: NSDecimalNumber = NSDecimalNumber(value: value.doubleValue)
        let resultDN: NSDecimalNumber = aDN.rounding(accordingToBehavior: decimalNumberHandler)
//        return resultDN.stringValue
        return reserveDecimalWithNumberString(resultDN.stringValue, decimalDigits: decimalDigits, autoAddZero: autoAddZero)
    }
    
    // 保留小数
    @objc static func reserveDecimalWithNumberString(_ stringNumber: String, decimalDigits: Int16, autoAddZero: Bool) -> String {
        // 防止传入Number类型
        let numberString: String = "\(stringNumber)"
        // 没有小数点
        if numberString.range(of: ".") == nil {
            if autoAddZero {
                // 自动补0
                var string_comp = "\(numberString)."
                for _ in 0..<decimalDigits {
                    string_comp.append("0")
                }
                return string_comp
            } else {
                // 不需要自动补0
                return numberString
            }
        } else {
            let arrays = numberString.components(separatedBy: ".")
            let s_f = arrays[0]
            var s_e = arrays[1]
            
            if s_e.count < decimalDigits {
                // 补0
                if autoAddZero {
                    while s_e.count < decimalDigits {
                        s_e.append("0")
                    }
                }
            }
            
            let string_combine = "\(s_f).\(s_e)"
            return string_combine
        }
    }
}
