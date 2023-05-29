# MyCommentInputBox
评论输入框


控件加约束
#### EditingBar   底部输入框
```
[self addSubview:_editView];
[self addSubview:_inputViewButton];
for (UIView *view in self.subviews) {
view.translatesAutoresizingMaskIntoConstraints = NO;
}
NSDictionary *views = NSDictionaryOfVariableBindings(_inputViewButton, _editView);

//_editView左边距是15  右边距离_inputViewButton为10 _inputViewButton宽度是55 _inputViewButton右边距是15
[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_editView]-10-[_inputViewButton(55)]-15-|"
options:0 metrics:nil views:views]];

//_inputViewButton上下间距为0
[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_inputViewButton]|" options:0 metrics:nil views:views]];

//_editView上下间隔都是5
[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_editView]-5-|" options:0 metrics:nil views:views]];
```

####  BottomBarViewController 
##### 设置属性
```
底部y坐标  距离底部0
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
高度
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;
```
##### 设置约束
```
_editingBarYConstraint = [NSLayoutConstraint constraintWithItem:self.view    attribute:NSLayoutAttributeBottom   relatedBy:NSLayoutRelationEqual
toItem:_editingBar  attribute:NSLayoutAttributeBottom   multiplier:1.0 constant:0];

_editingBarHeightConstraint = [NSLayoutConstraint constraintWithItem:_editingBar attribute:NSLayoutAttributeHeight         relatedBy:NSLayoutRelationEqual
toItem:nil         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:[self minimumInputbarHeight]];
```
##### 最后view添加约束
```
[self.view addConstraint:_editingBarYConstraint];
[self.view addConstraint:_editingBarHeightConstraint];
```
##### 修改约束
```
_editingBarYConstraint.constant = <#要修改的值大小#>;
self.editingBarHeightConstraint.constant = <#要修改的值大小#>;
```

#### 字数小于2的 禁止点击发送
在代理方法：`- (void)textViewDidChange:(UITextView *)textView`中判断text的长度，大于2的时候`_editingBar.inputViewButton.enabled = YES;
`，否则`_editingBar.inputViewButton.enabled = NO;`。
注：
在textView的委托法`textViewDidChange` 只能监听到通过监听到通过键盘输入、删除的内容改变，不能监听到setText,或者myTextView.text=@"Hello"这种内容改变方式，那么监听到这种直接赋值引起的改变需要KVO机制。两个方法要配合使用。
先给出示例代码：
```
//注册监听
[_editingBar.editView addObserver:self forKeyPath:kText options:NSKeyValueObservingOptionNew context:NULL];
//处理属性改变事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
UITextView *mTextView = object;
NSLog("the textView content is change!!");
}
```
要在`dealloc`中移除观察者 不然在iOS10系统会崩溃。
```
- (void)dealloc
{
[self.editingBar.editView removeObserver:self forKeyPath:kText];
}
```

发送的响应事件
点击发送按钮或者键盘的回车确定按钮，调用`sendContent`，在里面先判断`_editingBar.inputViewButton.enabled`，是`YES`的话就调用`sendContent`方法，否则不处理。
