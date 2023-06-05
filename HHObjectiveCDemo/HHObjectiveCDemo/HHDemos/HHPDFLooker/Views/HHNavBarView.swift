//
//  HHNavBarView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/6/5.
//

import UIKit

class HHNavBarView: UIView {
    @objc var titleLab: UILabel!
    @objc var leftItem: UIButton!
    @objc var rightItem: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.titleLab = UILabel()
        self.titleLab.textColor = .lightText
        self.titleLab.font = UIFont.systemFont(ofSize: 18)
        self.titleLab.textAlignment = .center
        self.leftItem = UIButton(type: .custom)
        self.rightItem = UIButton(type: .custom)
        self.addSubview(self.titleLab)
        self.addSubview(self.leftItem)
        self.addSubview(self.rightItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = 50
        let height: CGFloat = 44
        let left: CGFloat = 10
        let right: CGFloat = 10
        let bottom: CGFloat = 0
        
        self.leftItem.frame = CGRect(x: left, y: self.frame.size.height - height - bottom, width: size, height: height)
        self.rightItem.frame = CGRect(x: self.frame.size.width - right - size, y: self.frame.size.height - height - bottom, width: size, height: height)
        self.titleLab.frame = CGRect(x: left + size, y: self.frame.size.height - height, width: self.frame.size.width - (left + size) * 2, height: height)
    }
}
