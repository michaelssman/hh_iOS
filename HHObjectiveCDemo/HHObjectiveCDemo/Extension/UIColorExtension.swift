//
//  UIColorExtension.swift
//  HHSwift
//
//  Created by Michael on 2022/5/28.
//

import Foundation
import UIKit

extension UIColor {
    static let designKit = DesignKitPalette.self
    enum DesignKitPalette {
        public static let primary: UIColor = dynamicColor(light: UIColor(hex: 0x01C257), dark: UIColor(hex: 0x01C257))
        public static let background: UIColor = dynamicColor(light: .white, dark: .black)
        public static let secondaryBackground: UIColor = dynamicColor(light: UIColor(hex: 0xf1f2f8), dark: UIColor(hex: 0x1D1B20))
        public static let tertiaryBackground: UIColor = dynamicColor(light: .white, dark: UIColor(hex: 0x2C2C2E))
        public static let line: UIColor = dynamicColor(light: UIColor(hex: 0xcdcdd7), dark: UIColor(hex: 0x48484A))
        public static let primaryText: UIColor = dynamicColor(light: UIColor(hex: 0x111236), dark: .white)
        public static let secondaryText: UIColor = dynamicColor(light: UIColor(hex: 0x68697f), dark: UIColor(hex: 0x8E8E93))
        public static let tertiaryText: UIColor = dynamicColor(light: UIColor(hex: 0x8f90a0), dark: UIColor(hex: 0x8E8E93))
        public static let quaternaryText: UIColor = dynamicColor(light: UIColor(hex: 0xb2b2bf), dark: UIColor(hex: 0x8E8E93))

        static private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
            } else {
                // Fallback on earlier versions
                return light
            }
        }
    }
    
    //静态方法
    static func hexColor(_ hexValue: Int, alphaValue: Float) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255, green: CGFloat((hexValue & 0x00FF00) >> 8) / 255, blue: CGFloat(hexValue & 0x0000FF) / 255, alpha: CGFloat(alphaValue))
    }
    static func hexColor(_ hexValue: Int) -> UIColor {
        return hexColor(hexValue, alphaValue: 1)
    }
    ///便捷初始化方法
    convenience init(_ hexValue: Int, alphaValue: Float) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255, green: CGFloat((hexValue & 0x00FF00) >> 8) / 255, blue: CGFloat(hexValue & 0x0000FF) / 255, alpha: CGFloat(alphaValue))
    }
    convenience init(hex: Int) {
        self.init(hex, alphaValue: 1)
    }
    convenience init(_ hexValue: Int) {
        self.init(hexValue, alphaValue: 1)
    }

    //深色模式
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        } else {
            // Fallback on earlier versions
            return light
        }
    }
    
    //UIColor获取RGB色值
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }


    @objc func toImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
