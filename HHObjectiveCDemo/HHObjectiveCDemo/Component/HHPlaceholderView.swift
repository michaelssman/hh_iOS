//
//  HHPlaceholderView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/14.
//

/**
 OC调用：
 - (void)test {
 UIView *placeholderV = [[UIView alloc]initWithFrame:self.view.bounds];
 placeholderV.backgroundColor = [UIColor redColor];
 [self tableView];//创建UITableViewP
 [self.objects addObject:@"好的方式就哭了"];
 self.tableView.placeholderView = placeholderV;
 
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [self.objects removeAllObjects];
 [self.tableView reloadData];//reloadData方法里面会自动判断显示隐藏placeholderV
 });
 }
 */

import Foundation
import UIKit
extension UIView {
    private static var placeholderViewKey: Void?
    
    @objc var placeholderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &Self.placeholderViewKey) as? UIView
        }
        set {
            if let newPlaceholderView = newValue, newPlaceholderView != placeholderView {
                placeholderView?.removeFromSuperview()
                objc_setAssociatedObject(self, &Self.placeholderViewKey, newPlaceholderView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addSubview(newPlaceholderView)
                newPlaceholderView.isHidden = true
            }
        }
    }
    
    func showPlaceholderView() {
        placeholderView?.isHidden = false
        if let placeholderView = placeholderView {
            bringSubviewToFront(placeholderView)
        }
    }
    
    func hidePlaceholderView() {
        placeholderView?.isHidden = true
    }
    
}

class UITableViewP: UITableView {
    override func reloadData() {
        super.reloadData()
        setUpPlaceholderView()
    }
    private func setUpPlaceholderView() {
        let dataSource = self.dataSource
        let sections = dataSource?.numberOfSections?(in: self) ?? 1
        var rows = 0
        for section in 0..<sections {
            rows += dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
        }
        if rows == 0 {
            showPlaceholderView()
        } else {
            hidePlaceholderView()
        }
    }
}
