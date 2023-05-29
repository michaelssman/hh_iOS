# HHPlusPopView

根据LLWPlusPopView去做的修改。
贴吧、微博 发帖动画，可多屏展示。

下面是一个scrollView，scrollView可分页滑动。
scrollView上面添加button。

两个构造方法创建HHPlusPopView对象，一个带有行列参数，一个不带（使用默认参数，最多3列 4行）

## 插入
根据图片参数for循环，设置每一个button的x，y。
要先找到当前button在第几页page，根据在数组中的位置判断是第几页page。根据page来设置button在scrollView中的x坐标。

- loc
是第几列
- xMargin
左右两边的间隙。 x坐标等于xMargin加上itemWidth*loc。
#### 做动画的item
判断是否是第一页：
数组的下标小于一页的个数，那么就是第一页。

## 消失
获取当前页的所有button
延迟时间，按顺序去改变button的frame。
先把背景色改为透明，不会闪一下。

