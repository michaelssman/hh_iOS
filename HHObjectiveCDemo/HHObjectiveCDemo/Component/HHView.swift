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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
