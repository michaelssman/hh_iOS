//
//  String.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/5/30.
//

import Foundation
import UIKit

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
    
    // MARK: 根据文本内容计算高度    
    func heightWithMaxWidth(maxWidth: CGFloat, fontSize: CGFloat, bold: Bool = false) -> CGFloat {
        let font: UIFont
        if bold {
            font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            font = UIFont.systemFont(ofSize: fontSize)
        }
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        return heightWithMaxWidth(maxWidth: maxWidth, attributes: attributes)
    }
    
    func heightWithMaxWidth(maxWidth: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine]
        return self.boundingRect(with: size, options: options, attributes: attributes, context: nil).size.height
    }
    
    //计算文本宽度
    func calculateStringWidth(font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let size = attributedString.size()
        return size.width
    }
}
