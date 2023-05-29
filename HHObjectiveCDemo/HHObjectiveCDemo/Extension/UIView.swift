//
//  UIView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/4.
//

import Foundation
import UIKit
extension UIView {
    @objc func viewController() -> UIViewController? {
        var responder: UIResponder? = next
        while (responder != nil) {
            if responder!.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            responder = responder?.next
        }
        return nil
    }
}
