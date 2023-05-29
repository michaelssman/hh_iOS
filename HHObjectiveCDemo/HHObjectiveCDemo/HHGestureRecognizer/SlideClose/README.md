# MyGestureRemoveController
左滑下滑返回

#### 使用
1. 继承SlideCloseController
2. 添加滑动手势滑动返回功能
    `[super addGRWithView:_collectionView];`
3. 设置滑动返回的滑动方向`self.gestureResponseDirection`
    
#### 注：
- 如果没有导航控制器的 `SlideCloseController`的`init`方法中已经默认设置了`modalPresentationStyle` 不需再设置。
- 如果有导航控制器的 需要设置导航控制器的`modalPresentationStyle`为`UIModalPresentationOverCurrentContext`。
