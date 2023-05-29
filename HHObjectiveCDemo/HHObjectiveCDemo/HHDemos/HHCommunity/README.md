# HHCommunity
### 社区贴吧九宫格
#### GridImageView
如果要取消图片的点击事件， 不预览大图，响应的方法为每一条帖子数据的点击事件（进入详情）。
则可以直接设置：
```
_collectionView.userInteractionEnabled = NO;
```
取消响应即可。
