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
}
