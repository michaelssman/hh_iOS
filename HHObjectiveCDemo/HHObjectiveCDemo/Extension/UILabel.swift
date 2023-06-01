//
//  UILabel.swift
//  HHSwift
//
//  Created by Michael on 2023/2/3.
//

import Foundation
import UIKit

extension UILabel {
    
    @objc convenience init(textColor: UIColor, fontSize: CGFloat) {
        self.init()
        self.textColor = textColor
        font = .systemFont(ofSize: fontSize)
    }
    
    // MARK: 设置行间距
    @objc func setLineSpace(space: CGFloat) {
        guard text != nil else { return }
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedText!)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        //设置行间距
        paragraphStyle.lineSpacing = space - (font.lineHeight - font.pointSize)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text?.count ?? 0))
        attributedText = attributedString
    }
    
    /// label中特殊字符显示不同的样式
    /// - Parameters:
    ///   - text: 特殊字符
    ///   - color: 特殊字符的字体颜色
    ///   - font: 特殊字符的字体大小
    func setSpecialText(_ text: String, color: UIColor, font: UIFont) {
          // 传数字需要转换
          let text = "\(text)"
          // 如果不包含指定的字符串，直接return
          guard self.text?.contains(text) == true else {
              return
          }
          
          if let range = self.text?.range(of: text) {
              //将Range<String.Index>转换为NSRange
              let nsRange = NSRange(range, in: text)
              setSpecialTextWithRange(nsRange, color: color, font: font)
          }
      }
      
      func setSpecialTextWithRange(_ range: NSRange, color: UIColor, font: UIFont) {
          guard let attributedString = self.attributedText?.mutableCopy() as? NSMutableAttributedString else {
              return
          }
          
          // 设置字号
          attributedString.addAttribute(.font, value: font, range: range)
          // 设置文字颜色
          attributedString.addAttribute(.foregroundColor, value: color, range: range)
          // 设置中划线
//          attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 12))
          
          self.attributedText = attributedString
      }
}
