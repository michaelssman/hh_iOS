//
//  HHTabItem.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/3.
//

import UIKit

class HHTabItem: UIButton {
    // 标题
    @objc var title: String? {
        didSet {
            setTitle(title, for: .normal)
            calculateTitleWidth()
        }
    }
    // 标题字体
    @objc var titleFont: UIFont? {
        didSet {
            titleLabel?.font = titleFont
            calculateTitleWidth()
        }
    }
    // 标题宽度（只读属性）
    @objc private(set) var titleWidth: CGFloat = 0
    
    // 用于记录tabItem在缩放前的frame，在TabBar的属性itemFontChangeFollowContentScroll == true时会用到
    @objc private(set) var frameWithOutTransform: CGRect = .zero
    
    // 指示器内边距
    @objc var indicatorInsets: UIEdgeInsets = .zero {
        didSet {
            calculateIndicatorFrame()
        }
    }
    // 指示器frame
    @objc private(set) var indicatorFrame: CGRect = .zero
    
    // 徽标按钮
    @objc var badgeButton = HHBadgeButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // 按下HHTabBar时，不高亮该item
        adjustsImageWhenHighlighted = false
        addSubview(badgeButton)
    }
    
    private func updateFrameOfSubviews() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        imageEdgeInsets = .zero
        titleEdgeInsets = .zero
    }
    
    override var frame: CGRect {
        didSet {
            frameWithOutTransform = frame
            calculateIndicatorFrame()
            updateFrameOfSubviews()
            badgeButton.updateBadge()
        }
    }
    
    // 计算标题宽度
    private func calculateTitleWidth() {
        guard let title = title, let titleFont = titleFont else {
            titleWidth = 0
            return
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: titleFont]
        let boundingRect = (title as NSString).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        titleWidth = ceil(boundingRect.width)
    }
    
    // 计算指示器frame
    private func calculateIndicatorFrame() {
        let frame = frameWithOutTransform
        let insets = indicatorInsets
        indicatorFrame = CGRect(x: frame.origin.x + insets.left,
                                y: frame.origin.y + insets.top,
                                width: frame.size.width - insets.left - insets.right,
                                height: frame.size.height - insets.top - insets.bottom)
    }
}
