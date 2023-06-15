//
//  AlertView.swift
//  HHSwift
//
//  Created by Michael on 2023/1/3.
//

import UIKit

class AlertView: UIView {
    var sureClosure: ((_ clickOK: Bool) -> Void)?
    static let bgWidth: CGFloat = 250
    static let bgHeight: CGFloat = 140
    
    lazy var alertBgView: UIView = {
        let alertBgView: UIView =  UIView(frame: CGRect(x: (UIScreen.main.bounds.width - Self.bgWidth) * 0.5, y: (SCREEN_HEIGHT - Self.bgHeight) * 0.5 - 50, width: Self.bgWidth, height: Self.bgHeight))
        alertBgView.backgroundColor = .white
        alertBgView.layer.masksToBounds = true
        alertBgView.layer.cornerRadius = 6.0
        return alertBgView
    }()
    
    lazy var titleView: UILabel = {
        let titleView: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: Self.bgWidth, height: 90))
        titleView.textColor = UIColor(0x0D0D0D)
        titleView.font = UIFont.systemFont(ofSize: 14)
        titleView.textAlignment = .center
        titleView.numberOfLines = 0
        return titleView
    }()
    
    lazy var leftButton: UIButton = {
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 90, width: AlertView.bgWidth * 0.5, height: 50)
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(UIColor(0x0D0D0D), for: .normal)
        leftButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return leftButton
    }()
    
    lazy var rightButton: UIButton = {
        let rightButton: UIButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: AlertView.bgWidth * 0.5, y: 90, width: AlertView.bgWidth * 0.5, height: 50)
        rightButton.setTitle("设置", for: .normal)
        rightButton.setTitleColor(UIColor(0x477AFF), for: .normal)
        rightButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        return rightButton
    }()
    
    
    lazy var HLine: UIView = {
        let HLine: UIView = UIView(frame: CGRect(x: 0, y: 90, width: AlertView.bgWidth, height: 1))
        HLine.backgroundColor = UIColor(0xF2F2F2)
        return HLine
    }()
    
    lazy var VLine: UIView = {
        let VLine: UIView = UIView(frame: CGRect(x: (AlertView.bgWidth - 1) * 0.5, y: 90, width: 1, height: 50))
        VLine.backgroundColor = UIColor(0xF2F2F2)
        return VLine
    }()
    
    private
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.4)
        alertBgView.addSubview(titleView)
        alertBgView.addSubview(leftButton)
        alertBgView.addSubview(rightButton)
        alertBgView.addSubview(HLine)
        alertBgView.addSubview(VLine)
        addSubview(alertBgView)
        keyWindow().addSubview(self)
    }
    
    static func showAlertView(title: String, sureHandle: ((_ clickOK: Bool) -> Void)?) {
        let alertView: AlertView = AlertView(frame: UIScreen.main.bounds)//调用私有的init方法
        alertView.titleView.text = title
        alertView.sureClosure = sureHandle //操作从外面传进来，函数式编程
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelAction() {
        removeFromSuperview()
        if let handle = sureClosure {
            handle(false)
        }
    }
    @objc func sureAction() {
        removeFromSuperview()
        if let handle = sureClosure {
            handle(true)
        }
    }
    
    static func AlertViewForView() -> AlertView? {
        for (_, item) in keyWindow().subviews.reversed().enumerated() {
            if item.isKind(of: self) {
                return item as? AlertView
            }
        }
        return nil
    }
}
