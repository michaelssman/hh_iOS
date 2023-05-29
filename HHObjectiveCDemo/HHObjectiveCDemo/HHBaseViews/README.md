# MyBaseViews
一些基础的控件视图，提高开发效率


##### SearchTextField
###### 占位文字样式修改
```
UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(15, 66, 200, 50)];
[self.view addSubview:textfield];

NSDictionary *attr=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil];

NSAttributedString * attributeStr = [[NSAttributedString alloc]initWithString:@"我是一个字符串" attributes:attr];

textfield.attributedPlaceholder = attributeStr;
```
###### 简单的修改占位文字字体颜色
```
[textfield setValue:<#占位文字颜色#> forKeyPath:@"_placeholderLabel.textColor"];
```
###### 设置圆角
实在找不到什么有用的方法，所以干脆在UITextField控件底部添加一个view，设置底部的view的圆角和边线的样式。
#输入框提示图片
如下图所示样式：
![image.png](http://upload-images.jianshu.io/upload_images/1892989-8aba917b1441cbfb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
输入框内的提示图片，UITextField有两个属性，leftview和rightview，这两个属性分别能设置textField内的左右两边的视图，可以插入图片,我用最简单的代码来展示textField的leftview怎么实现。
```
UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuo"]];

UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 29)];
textField.leftView =imgView;
textField.leftViewMode = UITextFieldViewModeAlways;

[self addSubview:textField];
```
有一个问题设置提示图片的位置和大小：
```
textField.leftView.frame = CGRectMake(15, 7.5, 15, 14.3);
```
可以设置图片的大小，但是修改位置坐标不管用。
图片是紧紧贴在输入框的边缘的，那么该怎么设置边距呢？我们可以子类化一个TextField，去复写它的一个方法来设置leftView的位置
```
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
CGRect iconRect = [super leftViewRectForBounds:bounds];
iconRect.origin.x += 15; //向右偏15
return iconRect;
}
```
