# HHTabBarController
自定义左右切换按钮

## HHTabItem
自定义button
要把点击效果去除
- title属性
    就是设置button的属性
    1. title
    2. titleColor
    3. titleSelectedColor
    4. titleFont
- 计算titleWidth
- indicator
    1. 指示器Insets
    2. 指示器的frame   根据Insets计算指示器的frame
## HHTabBar
自定义view，上面添加一个scrollView，scrollView上添加items。
点击items中button会调用下面三个代理方法：
- 三个代理方法：
    1. 是否能切换到指定index
    2. 将要切换到指定index
    3. 已经切换到指定index
- 代理属性
- items
    两种方式
    1. 设置items
    2. 通过设置titles来创建items
- 指示器`_indicatorImageView`
    1. 指示器颜色
    2. 指示器图像
    3. 指示器圆角
    4. 指示器动画
    5. 指示器样式，frame。
- 标题的属性
    1. 颜色
    2. 选中时的颜色
    3. 字体
    4. 选中时的字体
- 左右边距
    1. 第一个item与左边或者上边的距离
    2. 最后一个item与右边或者下边的距离
- selectedItemIndex（选中某一个index）
    - 在setter方法中实现三个代理，并且切换位置，设置当前选中的index。
    - item的点击方法也会触发该方法。
    - 如果tabbar支持滚动，将选中的item放到tabbar的中央。
        - 必须是可滚动的并且放向是横向的才行
- 渐变效果
    1. item的颜色是否根据拖动位置显示渐变效果
    2. item的字体是否根据拖动位置显示渐变效果
    3. Item的选中背景是否随contentView滑动而移动
- 设置tabBar是否可以左右滑动、item的宽
    1. 设置tabBar是否可以左右滑动
    2. item的宽度
    3. 文字自适应宽度
        1. 设置边距
        2. item的最小宽度
#### 更新tabBar的item渐变和指示器位置
根据HHTabContentView内容的滚动，tabBar的item字体颜色和指示器位置要随着滑动而更改。
#### 点击tabBar的item
setItems创建item的时候`addTarget`，响应方法中设置tabBar的selectedItemIndex。setSelectedItemIndex方法中改变字体颜色和指示器位置。

## HHTabContentView
### 不带头部 内容是一个contentScrollView
- contentScrollView
    一个UIScrollView，在它的代理中做联动。
    `scrollViewDidEndDecelerating`中去设置tabBar的selectedItemIndex
    `scrollViewDidScroll`
        - 如果不是手势拖动 不处理
        - 处理滑动越界不处理
- tabBar
- viewControllers
    viewControllers的setter方法，只添加子控制器，但是不addSubview，在滑动显示时根据`(controller.isViewLoaded && !controller.view.superview)`判断是否应该添加到父控制器的view上。刚开始不显示的时候不加载，不浪费资源和时间。
- views
    
### 带有头部header 内容是containerTableView
主要是设置父tableView和子tableView的滑动。
- 整个View是tableView
    tableView只有一个cell。cell里面是scrollView，scorllView中有很多Controller的view。tabBar是tableView的组头sectionHeaderView。


- header头部固定不动的话，只需要设置tabBarStopOnTopHeight为header的高度即可。

向下滑动scrollView.contentOffset.y<0
滑动的时候，父tableView和子tableView都会调用，需要都处理。
1. 向下滑动，子tableView的contentOffset.y<0，就转为父tableView滑动。子tableView的contentOffset为CGPointZero。

向上滑：
self.containerTableView.contentOffset.y 大于0 并且 小于 stopY：父tableVIew滑动，子tableView不滑动。
self.containerTableView.contentOffset.y > stopY 父tableView不滑动，子tableView滑动。
self.containerTableView.contentOffset.y <= 0 父tableView不滑动，子tableView滑动。


# 更新frame
#### setFrame
tabContentView和tabBar的frame初始的时候可能没有设置，setFrame的时候需要更新items和views的frame。


先设置
