//
//  HHTabContentView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/4.
//

import UIKit

@objc enum HHTabHeaderStyle: Int {
    case Stretch
    case Follow
    case OnlyUp //header可以跟随滑动向上，不能向下
    case None   //header固定
}

protocol HHTabContentViewDelegate: NSObjectProtocol {
    /// 是否能切换到指定index
    func shouldSelectTab(_ tabContentView: HHTabContentView, index: Int) -> Bool
    /// 将要切换到指定index
    func willSelectTab(_ tabContentView: HHTabContentView, index: Int)
    /// 已经切换到指定index
    func didSelectedTab(_ tabContentView: HHTabContentView, index: Int)
}

class HHTabContentView: UIView, HHTabBarDelegate, HHTabContentScrollViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    /// 内容视图
    lazy var contentScrollView: HHTabContentScrollView = {
        let contentScrollView: HHTabContentScrollView = HHTabContentScrollView(frame: self.bounds)
        contentScrollView.delegate = self
        contentScrollView.hh_delegete = self
        contentScrollView.interceptRightSlideGuetureInFirstPage = self.interceptRightSlideGuetureInFirstPage
        contentScrollView.interceptLeftSlideGuetureInLastPage = self.interceptLeftSlideGuetureInLastPage
        return contentScrollView
    }()
    // MARK: 有header时的内容视图
    @objc var containerTableView: HHContainerTableView?
    private(set) var headerView: UIView?
    var headerViewDefaultHeight: CGFloat = 0
    var tabBarStopOnTopHeight: CGFloat = 0
    lazy var containerTableViewCell: UITableViewCell = {
        let containerTableViewCell: UITableViewCell = UITableViewCell()
        return containerTableViewCell
    }()
    //带有header和section的整个的tableView滚
    var canContentScroll: Bool = true
    var headerStyle: HHTabHeaderStyle = .Follow
    /**
     *  设置HeaderView
     *  @param headerView UIView
     *  @param style 头部拉伸样式
     *  @param headerHeight headerView的默认高度
     *  @param tabBarHeight tabBar的高度
     *  @param tabBarStopOnTopHeight 当内容视图向上滚动时，TabBar停止移动的位置
     *  @param frame 整个界面的frame，一般来说是[UIScreen mainScreen].bounds
     */
    @objc func setHeader(headerView: UIView?, style: HHTabHeaderStyle, headerHeight: CGFloat, tabBarHeight: CGFloat, tabBarStopOnTopHeight: CGFloat, frame: CGRect) {
        if headerView == nil {
            return
        }
        self.frame = frame
        self.headerView = headerView
        self.headerStyle = style
        self.headerViewDefaultHeight = headerHeight
        self.tabBarStopOnTopHeight = tabBarStopOnTopHeight
        contentScrollView.removeFromSuperview()
        containerTableView = HHContainerTableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .plain)
        containerTableView?.delegate = self
        containerTableView?.dataSource = self
        if style == .Stretch {
            let view: UIView = UIView(frame: self.headerView!.bounds)
            containerTableView?.tableHeaderView = view
            containerTableView?.addSubview(self.headerView!)
        } else {
            containerTableView?.tableHeaderView = self.headerView
        }
        containerTableView?.contentInsetAdjustmentBehavior = .never
        addSubview(containerTableView!)
        contentScrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: frame.height - tabBarHeight - tabBarStopOnTopHeight)
        tabBar.frame = CGRect(x: tabBar.frame.origin.x, y: 0, width: tabBar.bounds.width, height: tabBarHeight)
        containerTableViewCell.contentView.addSubview(contentScrollView)
        updateContentViewsFrame()
    }
    
    @objc var tabBar: HHTabBar = HHTabBar(frame: .zero) {
        didSet {
            tabBar.delegate = self
        }
    }
    @objc var views: Array<UIView> = [] {
        didSet {
            for (index, view) in views.enumerated() {
                view.frame = frameAtIndex(index: index)
                contentScrollView.addSubview(view)
            }
            contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.width * CGFloat(views.count), height: contentScrollView.bounds.height)
        }
    }
    @objc var viewControllers: Array<UIViewController> = [] {
        didSet {
            let containerVC: UIViewController? = self.viewController()
            var items: Array<HHTabItem> = Array()
            viewControllers.forEach { viewController in
                if containerVC != nil {
                    containerVC!.addChild(viewController)
                }
                let item: HHTabItem = HHTabItem(type: .custom)
                item.title = viewController.title
                items.append(item)
            }
            tabBar.items = items
            //更新scrollView的contentSize
            if contentScrollEnabled {
                contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.width * CGFloat(viewControllers.count), height: contentScrollView.bounds.height)
            }
        }
    }
    weak var delegate: HHTabContentViewDelegate?
    /// 设置被选中的Tab的Index，界面会自动切换
    var selectedTabIndex: Int {
        get {
            return tabBar.selectedItemIndex
        }
    }
    /**
     *  此属性仅在内容视图支持滑动时有效，它控制child view controller调用viewDidLoad方法的时机
     *  1. 值为YES时，拖动内容视图，一旦拖动到该child view controller所在的位置，立即加载其view
     *  2. 值为NO时，拖动内容视图，拖动到该child view controller所在的位置，不会立即展示其view，而是要等到手势结束，scrollView停止滚动后，再加载其view
     *  3. 默认值为NO
     */
    var loadViewOfChildControllerWhileAppear: Bool = false
    /**
     *  在此属性仅在内容视图支持滑动时有效，它控制chile view controller未选中时，是否将其从父view上面移除
     *  默认为false
     */
    var removeViewOfChildContollerWhileDeselected: Bool = false
    /**
     鉴于有些项目集成了左侧或者右侧侧边栏，当内容视图支持滑动切换时，不能实现在第一页向右滑动和最后一页向左滑动呼出侧边栏的功能，
     此2个属性则可以拦截第一页向右滑动和最后一页向左滑动的手势，实现呼出侧边栏的功能
     */
    @objc var interceptRightSlideGuetureInFirstPage: Bool = false {
        didSet {
            contentScrollView.interceptRightSlideGuetureInFirstPage = interceptRightSlideGuetureInFirstPage
        }
    }
    var interceptLeftSlideGuetureInLastPage: Bool = false {
        didSet {
            contentScrollView.interceptLeftSlideGuetureInLastPage = interceptLeftSlideGuetureInLastPage
        }
    }
    private var lastContentScrollViewOffsetX: CGFloat = 0
    var contentScrollEnabled: Bool = true
    var contentSwitchAnimated: Bool = true
    /// 获取被选中的Controller
    var selectedController: UIViewController {
        get {
            return viewControllers[selectedTabIndex]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _setup() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(contentScrollView)
        tabBar.delegate = self
    }
    override var frame: CGRect {
        didSet {
            if !CGRectEqualToRect(frame, .zero) {
                contentScrollView.frame = bounds
                updateContentViewsFrame()
            }
        }
    }
    
    /// 更新frame
    func updateContentViewsFrame() {
        if views.count > 0 {
            contentScrollView.contentSize = CGSizeMake(contentScrollView.bounds.width * CGFloat(views.count), contentScrollView.bounds.height)
            for (index, view) in views.enumerated() {
                view.frame = frameAtIndex(index: index)
            }
        } else {
            if contentScrollEnabled {
                contentScrollView.contentSize = CGSizeMake(contentScrollView.bounds.width * CGFloat(viewControllers.count), contentScrollView.bounds.height)
                for (index, viewController) in viewControllers.enumerated() {
                    viewController.view.frame = frameAtIndex(index: index)
                    viewController.hh_scrollView()?.frame = CGRect(x: 0, y: 0, width: frameAtIndex(index: index).width, height: frameAtIndex(index: index).height)
                }
                contentScrollView.scrollRectToVisible(selectedController.view.frame , animated: false)
            } else {
                contentScrollView.contentSize = contentScrollView.bounds.size
                selectedController.view.frame = contentScrollView.bounds
            }
        }
    }
    
    private func frameAtIndex(index: Int) -> CGRect {
        return CGRect(x: CGFloat(index) * contentScrollView.bounds.width, y: 0, width: contentScrollView.bounds.width, height: contentScrollView.bounds.height)
    }
    
    /// 设置内容视图支持滑动切换，以及点击item切换时是否有动画
    /// @param enabled 是否支持滑动切换
    /// @param animated 点击切换时是否支持动画
    func setContentScroll(enabled: Bool, animated: Bool) {
        if !contentScrollEnabled, enabled {
            contentScrollEnabled = enabled
            updateContentViewsFrame()
        }
        contentScrollView.isScrollEnabled = enabled
        contentSwitchAnimated = animated
    }
}

extension HHTabContentView {
    // MARK: HHTabBarDelegate
    func shouldSelectItem(_ tabBar: HHTabBar, index: Int) -> Bool {
        return shouldSelectItem(index: index)
    }
    func willSelectItem(_ tabBar: HHTabBar, index: Int) {
        if delegate != nil {
            delegate?.willSelectTab(self, index: index)
        }
    }
    /// 点击tab，切换内容页
    func didSelectedItem(_ tabBar: HHTabBar, oldIndex: Int, newIndex: Int) {
        if views.count > 0 {
            contentScrollView.setContentOffset(CGPoint(x: contentScrollView.bounds.width * CGFloat(newIndex), y: 0), animated: true)
            return
        }
        // TODO: 待做
        //        let oldController: UIViewController = viewControllers[oldIndex]
        //            oldController?.hh_tabItemDidDeselected()
        //旧controller取消选中
        if (!contentScrollEnabled || (contentScrollEnabled && removeViewOfChildContollerWhileDeselected)) {
            for (idx, viewController) in viewControllers.enumerated() {
                if idx != newIndex, viewController.isViewLoaded, viewController.view.superview != nil {
                    viewController.view.removeFromSuperview()
                }
            }
        }
        
        //对新controller设置
        let curController: UIViewController = viewControllers[newIndex]
        if contentScrollEnabled {// contentView支持滚动
            curController.view.frame = frameAtIndex(index: newIndex)
            if curController.isViewLoaded, curController.view.superview == nil {
                contentScrollView.addSubview(curController.view)
            }
            // 切换到curController
            contentScrollView.scrollRectToVisible(curController.view.frame, animated: contentSwitchAnimated)
        } else {// contentView不支持滚动
            curController.view.frame = contentScrollView.bounds
            contentScrollView.addSubview(curController.view)
        }
        // TODO: 待做
        if containerTableView != nil {
            curController.hh_scrollView()!.hh_didScollHandler = { [self] (scrollView: UIScrollView) -> Void in
                childScrollViewDidScroll(scrollView: scrollView)
            }
        }
        // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
        if curController.view.isKind(of: UIScrollView.self) {
            let scrollView: UIScrollView = curController.view as! UIScrollView
            scrollView.scrollsToTop = true
        }
        if delegate != nil {
            delegate?.didSelectedTab(self, index: newIndex)
        }
    }
    
    // MARK: HHTabContentScrollViewDelegate
    func scrollView(_ scrollView: HHTabContentScrollView, shouldScrollToPageIndex index: Int) -> Bool {
        return shouldSelectItem(index: index)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            containerTableView?.isScrollEnabled = true
            let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            tabBar.selectedItemIndex = page
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != containerTableView else {
            containerTableViewDidScroll(scrollView: scrollView)
            return
        }
        // 如果不是手势拖动导致的此方法被调用，不处理
        if (!(scrollView.isDragging || scrollView.isDecelerating)) {
            return;
        }
        containerTableView?.isScrollEnabled = false
        //        print("左右滑动")
        //滑动越界不处理
        let offsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewWidth: CGFloat = scrollView.frame.width
        if (offsetX < 0) || (offsetX > scrollView.contentSize.width - scrollViewWidth) {
            return
        }
        let leftIndex: Int = Int(offsetX / scrollViewWidth)
        var rightIndex: Int = leftIndex + 1
        if (delegate != nil) && (!scrollView.isDecelerating) {
            var targetIndex: Int
            if lastContentScrollViewOffsetX < offsetX {
                targetIndex = rightIndex
            } else {
                targetIndex = leftIndex
            }
            if targetIndex != selectedTabIndex {
                if !shouldSelectItem(index: targetIndex) {
                    scrollView.setContentOffset(CGPoint(x: selectedTabIndex * Int(scrollViewWidth), y: 0), animated: false)
                }
            }
        }
        lastContentScrollViewOffsetX = offsetX
        // 刚好处于能完整显示一个child view的位置
        if leftIndex == Int(offsetX / scrollViewWidth) {
            rightIndex = leftIndex
        }
        if viewControllers.count > 0 {
            // 将需要显示的child view放到scrollView上
            for index in leftIndex...rightIndex {
                let controller: UIViewController = viewControllers[index]
                if !controller.isViewLoaded, loadViewOfChildControllerWhileAppear {
                    controller.view.frame = frameAtIndex(index: index)
                }
                if controller.isViewLoaded, controller.view.superview == nil {
                    contentScrollView.addSubview(controller.view)
                }
            }
        }
        // 同步修改tabBar的子视图状态
        tabBar.updateSubViewsWhenParentScrollViewScroll(scrollView: contentScrollView)
    }
    
    private func shouldSelectItem(index: Int) -> Bool {
        if delegate != nil {
            return delegate!.shouldSelectTab(self, index: index)
        }
        return true
    }
    // MARK: 滚动逻辑处理
    /// 带有header的整个tableView的滑动
    func containerTableViewDidScroll(scrollView: UIScrollView) {
        print("内容视图竖向滚动时的y坐标偏移量\(scrollView.contentOffset.y)")
        if (headerStyle == .None) {
            containerTableView!.contentOffset = .zero
            return
        }
        let offsetY: CGFloat = scrollView.contentOffset.y
        let stopY: CGFloat = headerViewDefaultHeight - tabBarStopOnTopHeight;
        
        if !canContentScroll {
            // 这里通过固定contentOffset的值，来实现不滚动
            containerTableView!.contentOffset = CGPoint(x: 0, y: stopY)
        } else if (containerTableView!.contentOffset.y >= stopY) {
            containerTableView!.contentOffset = CGPoint(x: 0, y: stopY)
            canContentScroll = false
        }
        if (headerStyle == .OnlyUp) {
        }
        
        if (headerStyle == .Stretch) {
            if (offsetY <= 0) {
                headerView!.frame = CGRect(x: 0, y: offsetY, width: headerView!.frame.size.width, height: headerViewDefaultHeight - offsetY)
            }
        }
        scrollView.showsVerticalScrollIndicator = canContentScroll
    }
    /// 子tableView的滑动
    func childScrollViewDidScroll(scrollView: UIScrollView) {
        print("子tableView的滑动滑动\(scrollView.contentOffset.y)")
        
        if (headerStyle == .None) {
            containerTableView!.contentOffset = .zero
            return
        }
        if (self.headerStyle == .OnlyUp) {
            if (canContentScroll) {
                selectedController.hh_scrollView()!.contentOffset = .zero
            }
            if (selectedController.hh_scrollView()!.contentOffset.y <= 0) {
                selectedController.hh_scrollView()!.contentOffset = .zero
                viewControllers.forEach { viewController in
                    if viewController.isViewLoaded {
                        viewController.hh_scrollView()!.contentOffset = .zero
                    }
                }
                canContentScroll = true
            }
        } else {
            if (canContentScroll) {
                selectedController.hh_scrollView()!.contentOffset = .zero
            } else if (selectedController.hh_scrollView()!.contentOffset.y <= 0) {
                selectedController.hh_scrollView()!.contentOffset = .zero
                canContentScroll = true
                viewControllers.forEach { viewController in
                    if viewController.isViewLoaded {
                        viewController.hh_scrollView()!.contentOffset = .zero
                    }
                }
            }
        }
        scrollView.showsVerticalScrollIndicator = !canContentScroll;
    }
    // MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return containerTableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contentScrollView.frame.height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tabBar.frame.height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tabBar
    }
}

class HHContainerTableView: UITableView, UIGestureRecognizerDelegate {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        //子tableView可以点击状态栏 回到顶部
        scrollsToTop = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //是否支持多时候触发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

@objc protocol HHTabContentScrollViewDelegate: NSObjectProtocol {
    /// 是否能切换到指定index
    @objc optional func shouldScrollToPageIndex(_ scrollView: HHTabContentScrollView, index: Int) -> Bool
}
class HHTabContentScrollView: UIScrollView {
    var interceptLeftSlideGuetureInLastPage: Bool = false
    var interceptRightSlideGuetureInFirstPage: Bool = false
    weak var hh_delegete: HHTabContentScrollViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        isPagingEnabled = true
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view: UIView? = super.hitTest(point, with: event)
        guard let view = view else { return view }
        if view.isKind(of: UISlider.self) {
            isScrollEnabled = false
        } else {
            isScrollEnabled = true
        }
        return view
    }
    
    //重写此方法，在需要的时候，拦截UIPanGestureRecognizer
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGestureRecognizer: UIPanGestureRecognizer? = gestureRecognizer as? UIPanGestureRecognizer
        guard let panGestureRecognizer = panGestureRecognizer else { return true }
        
        //计算可能切换到的index
        let currentIndex: Int = Int(self.contentOffset.x / self.frame.size.width)
        var targetIndex: Int = currentIndex
        
        let translation: CGPoint = panGestureRecognizer.translation(in: self)
        if (translation.x > 0) {
            targetIndex = currentIndex - 1
        } else {
            targetIndex = currentIndex + 1
        }
        
        //第一页往右滑动
        if self.interceptRightSlideGuetureInFirstPage, targetIndex < 0 {
            return false
        }
        
        //最后一页往左滑动
        if self.interceptLeftSlideGuetureInLastPage {
            let numberOfPage: Int = Int(self.contentSize.width / self.frame.size.width)
            if (targetIndex >= numberOfPage) {
                return false
            }
        }
        
        //其他情况
        if self.hh_delegete != nil, self.hh_delegete!.responds(to: #selector(HHTabContentScrollViewDelegate.shouldScrollToPageIndex(_: index:))) {
            return self.hh_delegete!.shouldScrollToPageIndex!(self, index: targetIndex)
        }
        
        return true
        
    }
}
