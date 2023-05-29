//
//  HHTabBar.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/4.
//

import UIKit

// MARK: 指示器样式
@objc enum HHTabBarIndicatorStyle: Int {
    case FitItem
    case FitTitle
    case FixedWidth ///固定宽度
}

protocol HHTabBarDelegate: AnyObject {
    /// 是否能切换到指定index
    func shouldSelectItem(_ tabBar: HHTabBar, index: Int) -> Bool
    /// 将要切换到指定index
    func willSelectItem(_ tabBar: HHTabBar, index: Int)
    /// 已经切换到指定index
    func didSelectedItem(_ tabBar: HHTabBar, oldIndex: Int, newIndex: Int)
}

class HHTabBar: UIView {
    /// titles setter方法内部会创建items
    @objc var titles: [String] = [] {
        didSet {
            var tempItems: Array<HHTabItem> = []
            titles.forEach { title in
                let item: HHTabItem = HHTabItem()
                item.title = title
                tempItems.append(item)
            }
            items = tempItems
        }
    }
    /// items
    @objc var items: [HHTabItem] = [] {
        didSet {
            selectedItemIndex = 0
            //将老的item从superview上移除
            oldValue.forEach { item in
                item.removeFromSuperview()
            }
            //初始化每一个item
            items.forEach { item in
                item.setTitleColor(itemTitleColor, for: .normal)
                item.setTitleColor(itemTitleSelectedColor, for: .selected)
                item.titleFont = itemTitleFont
                item.addTarget(self, action: #selector(tabItemClicked(sender:)), for: .touchUpInside)
                scrollView.addSubview(item)
            }
            //更新item的大小缩放
            updateItemsScaleIfNeeded()
            updateAllUI()
        }
    }
    /// 第一个item与左边或者上边的距离
    var leadingSpace: CGFloat = 0 {
        didSet {
            updateAllUI()
        }
    }
    /// 最后一个item与右边或者下边的距离
    var trailingSpace: CGFloat = 0 {
        didSet {
            updateAllUI()
        }
    }
    /// 设置选中某一个item
    @objc var selectedItemIndex: Int = 0 {
        didSet {
            //是否可以点击
            if let delegate = delegate {
                let result = delegate.shouldSelectItem(self, index: selectedItemIndex)
                if !result {
                    return
                }
                delegate.willSelectItem(self, index: oldValue)
            }
            let oldSelectedItem: HHTabItem = items[oldValue]
            oldSelectedItem.isSelected = false
            if itemFontChangeFollowContentScroll {
                // 如果支持字体平滑渐变切换，则设置item的scale
                oldSelectedItem.transform = CGAffineTransformMakeScale(itemTitleUnselectedFontScale(), itemTitleUnselectedFontScale())
                oldSelectedItem.titleFont = itemTitleFont.withSize(itemTitleSelectedFont.pointSize)
            } else {
                oldSelectedItem.titleFont = itemTitleFont
            }
            let newSelectedItem: HHTabItem = items[selectedItemIndex]
            newSelectedItem.isSelected = true
            if itemFontChangeFollowContentScroll {
                // 如果支持字体平滑渐变切换，则设置item的scale
                newSelectedItem.transform = CGAffineTransformMakeScale(1, 1)
            }
            newSelectedItem.titleFont = itemTitleSelectedFont
            UIView.animate(withDuration: 0.25) { [self] in
                updateIndicatorFrame(index: selectedItemIndex)
            }
            // 如果tabbar支持滚动，将选中的item放到tabbar的中央
            setSelectedItemCenter()
            delegate?.didSelectedItem(self, oldIndex: oldValue, newIndex: selectedItemIndex)
        }
    }
    /// 拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为true
    @objc var itemColorChangeFollowContentScroll: Bool = true
    /// 拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为true
    @objc var itemFontChangeFollowContentScroll: Bool = true
    /// TabItem的选中背景是否随contentView滑动而移动
    @objc var indicatorScrollFollowContent: Bool = true
    /// TabBar选中切换时，指示器是否有动画
    @objc var indicatorSwitchAnimated: Bool = false
    /// 切换选中item的代理
    weak var delegate: HHTabBarDelegate?
    //已选中的item
    @objc var selectedItem: HHTabItem {
        get {
            return items[selectedItemIndex]
        }
    }
    // MARK: item样式 ----- start
    /// 标题颜色
    @objc var itemTitleColor: UIColor = .lightText {
        didSet {
            items.forEach { item in
                item.setTitleColor(itemTitleColor, for: .normal)
            }
        }
    }
    /// 选中时标题的颜色
    @objc var itemTitleSelectedColor: UIColor = .black {
        didSet {
            items.forEach { item in
                item.setTitleColor(itemTitleSelectedColor, for: .selected)
            }
        }
    }
    /// 标题字体
    @objc var itemTitleFont: UIFont = .systemFont(ofSize: 10) {
        didSet {
            if itemFontChangeFollowContentScroll {
                // item字体支持平滑切换，更新每个item的scale
                updateItemsScaleIfNeeded()
            } else {
                // 更新未选中的item
                items.forEach { item in
                    if !item.isSelected {
                        item.titleFont = itemTitleFont
                    }
                }
            }
            if itemFitTextWidth {
                // 如果item的宽度是匹配文字的，更新item的位置
                updateItemsFrame();
            }
            updateIndicatorFrame(index: selectedItemIndex)
        }
    }
    /// 选中时标题的字体
    @objc var itemTitleSelectedFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            selectedItem.titleFont = itemTitleSelectedFont
            updateItemsScaleIfNeeded()
        }
    }
    /// item是否匹配title的文字宽度
    var itemFitTextWidth: Bool = true
    // MARK: item样式 ----- end
    
    // MARK: 指示器 ----- start
    /// 选中背景
    lazy var indicatorImageView: UIImageView = {
        let indicatorImageView: UIImageView = UIImageView(frame: .zero)
        return indicatorImageView
    }()
    /// item指示器颜色
    @objc var indicatorColor: UIColor = .red {
        didSet {
            indicatorImageView.backgroundColor = indicatorColor
        }
    }
    /// item指示器图像
    @objc var indicatorImage: UIImage = UIImage() {
        didSet {
            indicatorImageView.image = indicatorImage
        }
    }
    /// item指示器圆角
    @objc var indicatorCornerRadius: CGFloat = 5.0 {
        didSet {
            indicatorImageView.clipsToBounds = true
            indicatorImageView.layer.cornerRadius = indicatorCornerRadius
        }
    }
    /// 指示器样式
    @objc var indicatorStyle: HHTabBarIndicatorStyle = .FitItem
    @objc var indicatorInsets: UIEdgeInsets = .zero
    @objc var indicatorWidth: CGFloat = 55
    @objc var indicatorWidthFixTitleAdditional: CGFloat = 55
    // MARK: 指示器 ----- end
    
    /// TabBar支持滚动时，需要使用此scrollView
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    /// 当item匹配title的文字宽度时，左右留出空隙，item的宽度 = 文字宽度 + spacing
    private var itemFitTextWidthSpacing: CGFloat = 0
    /// item的属性
    /// 固定宽度
    private var itemWidth: CGFloat = 55
    private var itemMinWidth: CGFloat = 55
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        backgroundColor = .white
        addSubview(scrollView)
        clipsToBounds = true
        scrollView.clipsToBounds = true
        scrollView.addSubview(indicatorImageView)
    }
    override var frame: CGRect {
        didSet {
            if !CGSizeEqualToSize(oldValue.size, frame.size) {
                self.scrollView.frame = bounds
                updateAllUI()
            }
        }
    }
    func updateAllUI() {
        updateItemsFrame()
        //更新items的indicatorInsets
        updateItemIndicatorInsets()
        updateIndicatorFrame(index: selectedItemIndex)
    }
    /// 更新item字体的大小缩放
    private func updateItemsScaleIfNeeded() {
        if itemFontChangeFollowContentScroll, itemTitleSelectedFont.pointSize != itemTitleFont.pointSize {
            let normalFont: UIFont = itemTitleFont.withSize(itemTitleSelectedFont.pointSize)
            items.forEach { item in
                if item.isSelected {
                    item.titleFont = itemTitleSelectedFont
                } else {
                    item.titleFont = normalFont
                    item.transform = CGAffineTransformMakeScale(itemTitleUnselectedFontScale(), itemTitleUnselectedFontScale())
                }
            }
        }
    }
    //更新item的frame
    private func updateItemsFrame() {
        if items.isEmpty {
            return
        }
        if scrollView.isScrollEnabled {//支持滚动
            var x: CGFloat = leadingSpace
            for index in 0..<items.count {
                let item: HHTabItem = items[index]
                var width: CGFloat = 0
                //item的宽度为一个固定值
                if itemWidth > 0 {
                    width = itemWidth
                }
                //item的宽度为根据字体大小和spacing进行适配
                if itemFitTextWidth {
                    width = max(item.titleWidth + itemFitTextWidthSpacing, itemMinWidth)
                }
                item.frame = CGRect(x: x, y: 0, width: width, height: frame.height)
                item.tag = index
                x += width
            }
            scrollView.contentSize = CGSize(width: max(x + trailingSpace, scrollView.frame.width), height: scrollView.frame.height)
        } else {//不支持滚动
            var x: CGFloat = leadingSpace
            let allItemsWidth: CGFloat = frame.width - leadingSpace - trailingSpace
            //多加0.5，防止字体模糊
            itemWidth = allItemsWidth / CGFloat(items.count) + 0.5
            for index in 0..<items.count {
                let item: HHTabItem = items[index]
                item.frame = CGRect(x: x, y: 0, width: itemWidth, height: frame.height)
                item.tag = index
                x += itemWidth
            }
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height)
        }
    }
    
    // MARK: 设置item的width
    /// item宽度固定
    /// @param width 每个item的固定宽度
    @objc func setScrollEnabledAndItemWidth(width: CGFloat) {
        scrollView.isScrollEnabled = true
        itemWidth = width
        itemFitTextWidth = false
        itemFitTextWidthSpacing = 0
        itemMinWidth = 0
        updateItemsFrame()
    }
    
    /// item的宽度跟随text自适应
    /// - Parameters:
    ///   - spacing: item的width的space
    ///   - minWidth: 最小宽度
    @objc func setScrollEnabledAndItemFitTextWidthWithSpacing(spacing: CGFloat, minWidth: CGFloat) {
        scrollView.isScrollEnabled = true
        itemWidth = 0
        itemFitTextWidth = true
        itemFitTextWidthSpacing = spacing
        itemMinWidth = minWidth
        updateItemsFrame()
    }
    
    //点击tabBar的item
    @objc func tabItemClicked(sender: HHTabItem) {
        selectedItemIndex = sender.tag
    }
    
    // MARK: 指示器----- start
    /// 设置tabItem的选中背景，这个背景可以是一个横条。
    /// 此方法与setIndicatorWidthFixTextWithTop互斥，后调用着生效
    /// @param insets 选中背景的insets
    /// @param animated 点击item进行背景切换的时候，是否支持动画
    func setIndicator(insets: UIEdgeInsets, animated: Bool) {
        indicatorStyle = .FitItem
        indicatorSwitchAnimated = animated
        indicatorInsets = insets
        updateItemIndicatorInsets()
        updateIndicatorFrame(index: selectedItemIndex)
    }
    /// 设置指示器的宽度根据title宽度来匹配
    /// 此方法与setIndicatorInsets方法互斥，后调用者生效
    /// @param top 指示器与tabItem顶部的距离
    /// @param bottom 指示器与tabItem底部的距离
    /// @param additional 指示器与文字宽度匹配后额外增加或减少的长度，0表示相等，正数表示较长，负数表示较短
    /// @param animated 点击item进行背景切换的时候，是否支持动画
    @objc func setIndicatorWidthFitText(top: CGFloat, bottom: CGFloat, additional: CGFloat, animated: Bool) {
        indicatorStyle = .FitTitle
        indicatorSwitchAnimated = animated
        indicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        indicatorWidthFixTitleAdditional = additional
        updateItemIndicatorInsets()
        updateIndicatorFrame(index: selectedItemIndex)
    }
    /// 设置指示器固定宽度
    /// @param width 指示器宽度
    /// @param top 指示器与tabItem顶部的距离
    /// @param bottom 指示器与tabItem底部的距离
    /// @param animated 点击item进行背景切换的时候，是否支持动画
    func setIndicator(width: CGFloat, top: CGFloat, bottom: CGFloat, animated: Bool) {
        indicatorStyle = .FixedWidth
        indicatorSwitchAnimated = animated
        indicatorInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        indicatorWidth = width
        updateItemIndicatorInsets()
        updateIndicatorFrame(index: selectedItemIndex)
    }
    
    // 更新指示器inset
    func updateItemIndicatorInsets() {
        if items.isEmpty {
            return
        }
        if indicatorStyle == .FitTitle {
            items.forEach { item in
                let frame: CGRect = item.frameWithOutTransform
                let space: CGFloat = (frame.size.width - item.titleWidth - indicatorWidthFixTitleAdditional) / 2.0
                item.indicatorInsets = UIEdgeInsets(top: indicatorInsets.top, left: space, bottom: indicatorInsets.bottom, right: space)
            }
        } else if indicatorStyle == .FixedWidth {
            items.forEach { item in
                let frame: CGRect = item.frameWithOutTransform
                let space: CGFloat = (frame.size.width - indicatorWidth) / 2.0
                item.indicatorInsets = UIEdgeInsets(top: indicatorInsets.top, left: space, bottom: indicatorInsets.bottom, right: space)
            }
        } else if indicatorStyle == .FitItem {
            items.forEach { item in
                item.indicatorInsets = indicatorInsets
            }
        }
    }
    /// 更新指示器的frame
    func updateIndicatorFrame(index: Int) {
        if (items.isEmpty || (index == NSNotFound)) {
            indicatorImageView.frame = .zero
            return
        }
        let item = items[index]
        indicatorImageView.frame = item.indicatorFrame
    }
    // MARK: 指示器----- end
    //获取未选中字体与选中字体大小的比例
    func itemTitleUnselectedFontScale() -> CGFloat {
        return itemTitleFont.pointSize / itemTitleSelectedFont.pointSize
    }
    
    // 如果tabbar支持滚动，将选中的item放到tabbar的中央
    func setSelectedItemCenter() {
        if !scrollView.isScrollEnabled {
            return
        }
        //修改偏移量
        var offsetX: CGFloat = selectedItem.center.x - scrollView.frame.width * 0.5
        //处理最小滚动偏移量
        if offsetX < 0 {
            offsetX = 0
        }
        //处理最大滚动偏移量
        let maxOffsetX: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
    
    // MARK: 更新tabBar的item渐变和指示器位置
    func updateSubViewsWhenParentScrollViewScroll(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.width
        
        let leftIndex: Int = Int(offsetX / scrollViewWidth)
        let rightIndex: Int = leftIndex + 1
        if (rightIndex > items.count - 1) {
            return
        }
        let leftItem: HHTabItem = items[leftIndex]
        let rightItem: HHTabItem = items[rightIndex]
        // 计算右边按钮偏移量
        var rightScale: CGFloat = offsetX / scrollViewWidth
        // 只想要 0～1
        rightScale = rightScale - CGFloat(leftIndex)
        let leftScale: CGFloat = 1 - rightScale
        //item字体渐变
        if itemFontChangeFollowContentScroll, itemTitleUnselectedFontScale() != 1.0 {
            // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
            // 计算字体大小的差值
            let diff: CGFloat = itemTitleUnselectedFontScale() - 1
            // 根据偏移量和差值，计算缩放值
            leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1)
            rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1)
        }
        
        // item颜色渐变
        if (itemColorChangeFollowContentScroll) {
            var normalRed: CGFloat = 0, normalGreen: CGFloat = 0, normalBlue: CGFloat = 0, normalAlpha: CGFloat = 0
            var selectedRed: CGFloat = 0, selectedGreen: CGFloat = 0, selectedBlue: CGFloat = 0, selectedAlpha: CGFloat = 0
            itemTitleColor.getRed(&normalRed, green: &normalGreen, blue: &normalBlue, alpha: &normalAlpha)
            itemTitleSelectedColor.getRed(&selectedRed, green: &selectedGreen, blue: &selectedBlue, alpha: &selectedAlpha)
            // 获取选中和未选中状态的颜色差值
            let redDiff: CGFloat = selectedRed - normalRed
            let greenDiff: CGFloat = selectedGreen - normalGreen
            let blueDiff: CGFloat = selectedBlue - normalBlue
            let alphaDiff: CGFloat = selectedAlpha - normalAlpha
            // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
            let leftColor: UIColor = UIColor(red: leftScale * redDiff + normalRed, green: leftScale * greenDiff + normalGreen, blue: leftScale * blueDiff + normalBlue, alpha: leftScale * alphaDiff + normalAlpha)
            let rightColor: UIColor = UIColor(red: rightScale * redDiff + normalRed, green: rightScale * greenDiff + normalGreen, blue: rightScale * blueDiff + normalBlue, alpha: rightScale * alphaDiff + normalAlpha)
            leftItem.titleLabel?.textColor = leftColor
            rightItem.titleLabel?.textColor = rightColor
        }
        
        // 指示器frame
        if (indicatorScrollFollowContent) {
            var frame: CGRect = indicatorImageView.frame
            let xDiff: CGFloat = rightItem.indicatorFrame.origin.x - leftItem.indicatorFrame.origin.x
            
            frame.origin.x = rightScale * xDiff + leftItem.indicatorFrame.origin.x
            
            let widthDiff: CGFloat = rightItem.indicatorFrame.size.width - leftItem.indicatorFrame.size.width
            frame.size.width = rightScale * widthDiff + leftItem.indicatorFrame.size.width
            
            indicatorImageView.frame = frame
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
