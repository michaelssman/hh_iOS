//
//  HHView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/21.
//

import UIKit

class HHView: UIView {
    
    // MARK: 回收键盘
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let view = view {
            if !(view.isKind(of: UITextView.self)), !(view.isKind(of: UITextField.self)) {
                self.endEditing(true)
            }
        }
        return view
    }
    
    //    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    //        // 1.判断当前控件能否接收事件
    //        if (isUserInteractionEnabled == false || isHidden == true || alpha <= 0.01) {
    //            return nil
    //        }
    //        // 2. 判断点在不在当前控件
    //        if self.point(inside: point, with: event) == false {
    //            return nil
    //        }
    //        // 3.从后往前遍历自己的子控件
    //        for view in subviews.reversed() {
    //            // 把当前控件上的坐标系转换成子控件上的坐标系
    //            let childPoint: CGPoint = self.convert(point, to: view)
    //            if let fitView = view.hitTest(childPoint, with: event) {
    //                return fitView // 寻找到最合适的view
    //            }
    //        }
    //        // 循环结束,表示没有比自己更合适的view
    //        return self
    //    }
    
    
    /// 设置阴影
    /// - Parameters:
    ///   - radius: 设置阴影的模糊程度
    ///   - color: 设置阴影的颜色
    ///   - opacity: 设置阴影的不透明度（0.0表示完全透明，1.0表示完全不透明）
    func setUpShadow(radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowColor = color.cgColor
        // 设置阴影的偏移量（width和height表示水平和垂直方向上的偏移量）
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
