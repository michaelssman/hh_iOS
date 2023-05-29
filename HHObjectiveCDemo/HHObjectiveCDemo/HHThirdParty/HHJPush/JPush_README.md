# 极光推送
## 推送支持图片
### 新建一个UNNotificationServiceExtension
1. 在菜单栏下选择File-->New-->Target
2. 然后选Notification Service Extension创建Target；
3. 在Product Name栏中填写名字HHNotificationSE，点击Finish
4. 此时我们的目录结构里面，已经多出了一个文件夹（HHNotificationSE）。到这一步，我们就新建了一个服务通知类的扩展。
### 实现自定义通知内容样式
在`NotificationService.m`文件中去实现
1. 处理通知内容重写的方法
2. 下载通知附件的方法
3. 判断文件类型的方法

### 推送的内容格式
> {
"aps": {
"alert": "This is some fancy message.",
"badge": 1,
"sound": "default",
"mutable-content": "1",
"imageAbsoluteString": "http://upload.univs.cn/2012/0104/1325645511371.jpg"
}
}
#### 注意
1. 一定要有"mutable-content":"1",
以及一定要有Alert的字段，否则可能会拦截通知失败（苹果文档说的）。除此之外，我们还可以添加自定义字段，比如，图片地址，图片类型。
在极光后台设置参数（必须选中下面的mutable-content，否则通知消息不会变化）。
2. Deployment Target设置
选中工程---> UNNotificationServiceExtension所对应的Target-->Deployment Target设置为iOS10，因为是从iOS10才支持推送多媒体文件，它默认是从当前Xocde支持的最高版本，比如测试的手机版本iOS10.0.2，它默认是iOS 10.2.0.刚开始没有修改，推送死活出不来图片，只有文字；后台检查才发现这里是从iOS 10.2.0支持的。
3. 推送不显示图片，图片的url地址是http的，不是https的，所以要在info.plist中添加允许http。
4. 调试不走NotificationService断点和不打印Log：target应该选择NotificationSE的target。
