# HHChapterDemo
多级章节目录 类别
有多层

一个tableView，section为1。
使用一个多维数组，数组里面包括子数组（元素是model对象，model里面有一个model属性），子数组里面又包括子子数组，子子数组里面又是数组。使用递归。


model 里面属性：
1. 标题
2. 是否展开或者收起
3. 等级
4. model（子目录）

在model的- (void)setValue:(id)value forKey:(NSString *)key方法中递归把子类也变为model。

### 展开合闭
每一个cell都可以点击
在tableView的didSelectRowAtIndexPath代理方法中处理
如果当前model的isOpen是false，那么就展开。
如果当前model的isOpen是true，那么就关闭。
重新设置数据源。刷新tableView。

### 等级
为model添加grade属性，表示当前是第几级。在设置model中key的value的时候，需要给grade赋值。
