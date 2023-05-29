//
//  ViewController.m
//  HHGestureRecognizer
//
//  Created by FN-116 on 2021/11/8.
//

#import "HHGestureRecognizerViewController.h"
#import "SlideCloseTestViewController.h"
@interface HHGestureRecognizerViewController ()

@end

@implementation HHGestureRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 300, 300)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    //手势识别器需要添加到需要识别的视图上
   /* {
    //轻拍手势
    //1：创建轻拍手势
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]init];
    //2:为识别器添加指定操作
    [tapG addTarget:self action:@selector(handleTapGesture:)];
    //设置轻拍次数
    tapG.numberOfTapsRequired = 2;
    //3：将识别器添加到对应的视图上
    [redView addGestureRecognizer:tapG];
    //4:释放所有权
    [tapG release];
    } */
    //长按手势
   /* {
    UILongPressGestureRecognizer *longPressG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [redView addGestureRecognizer:longPressG];
    //设置长按手势判定的最小时间
    longPressG.minimumPressDuration = 20.0;
    [longPressG release];
    }  */
    //轻扫手势
   /* {
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [redView addGestureRecognizer:swipG];
    //设置轻扫手势的方向
    //如果想要实现多个方向的轻扫，需要给redView添加多个轻扫手势
    swipG.direction = UISwipeGestureRecognizerDirectionUp;
    [swipG release];
    UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [redView addGestureRecognizer:swipDown];
    swipDown.direction = UISwipeGestureRecognizerDirectionDown;
    [swipDown release];
    } */
    //平移手势
   /* UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [redView addGestureRecognizer:panG];
    [panG release]; */
    //旋转手势
    UIRotationGestureRecognizer *rotateG = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRoateGestureAction:)];
    [redView addGestureRecognizer:rotateG];
    //捏合手势
    UIPinchGestureRecognizer *pinchG = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    [redView addGestureRecognizer:pinchG];
    //屏幕边缘
    UIScreenEdgePanGestureRecognizer *screenG = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleScreenEdgePanGesture:)];
    //设置屏幕边沿平移手势的执行方向
    screenG.edges = UIRectEdgeLeft;
    [redView addGestureRecognizer:screenG];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"test" style:UIBarButtonItemStyleDone target:self action:@selector(testAction)];
}
//定义屏幕边沿平移手势
- (void)handleScreenEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)screenG {
    //改变指定视图的transform属性
    CGPoint offset = [screenG translationInView:screenG.view];
    screenG.view.transform = CGAffineTransformTranslate(screenG.view.transform, offset.x, offset.y);
    [screenG setTranslation:CGPointZero inView:screenG.view];
}
//定义方法实现捏合操作
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchG {
    //修改指定视图的transform属性
//    pinchG.view.transform = CGAffineTransformMakeScale(pinchG.scale, pinchG.scale);//以最初的状态为基准
    pinchG.view.transform = CGAffineTransformScale(pinchG.view.transform, pinchG.scale, pinchG.scale);
    //将放大比例归1
    pinchG.scale = 1.0;
}
//处理旋转手势的操作
- (void)handleRoateGestureAction:(UIRotationGestureRecognizer *)roate {
    //设置视图的transform属性
//    roate.view.transform = CGAffineTransformMakeRotation(roate.rotation);//旋转的时候以最初的状态为基础
    roate.view.transform = CGAffineTransformRotate(roate.view.transform, roate.rotation);
    //将角度归零
    roate.rotation = 0.0;
}
//定义完成平移手势的操作
- (void)handlePanGesture:(UIPanGestureRecognizer *)panG {
    //1:获取在指定视图上平移的偏移量
//    CGPoint offset = [panG translationInView:panG.view];
//    panG.view.center = CGPointMake(panG.view.center.x + offset.x, panG.view.center.y + offset.y);
//    //将偏移量执行归零操作
//    [panG setTranslation:CGPointZero inView:panG.view];
    //VIP仿射变换执行平移操作
    //1:获得当前的偏移量
    CGPoint offset = [panG translationInView:panG.view];
    //2:修改视图的transform属性（获得变换之后的点）
//    panG.view.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);//该方法每次在进行映射的时候都是以最初的状态为基准
    panG.view.transform = CGAffineTransformTranslate(panG.view.transform, offset.x, offset.y);
    //3：将偏移量归零
    [panG setTranslation:CGPointZero inView:panG.view];
}
//定义一个处理轻扫手势的操作
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipG {
    UIView *redView = swipG.view;
    redView.backgroundColor = [UIColor randomColor];
}
//定义一个方法执行轻拍手势操作
- (void)handleTapGesture:(UITapGestureRecognizer *)tapG {
//    NSLog(@"%s   %d",__FUNCTION__,__LINE__);
    //获取识别器所在的视图
    UIView *redView = tapG.view;
    redView.backgroundColor = [UIColor randomColor];
    
}
//定义处理长按手势的操作
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressG {
    //将长按手势的状态设置为开始状态
    if (longPressG.state == UIGestureRecognizerStateBegan) {
        UIView *redView = longPressG.view;
        redView.superview.backgroundColor = [UIColor randomColor];
    }
}


#pragma mark - 某些视图上面不处理手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    //滑动手势
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        if ([touch.view isDescendantOfView:self.postersView]) {
//            return NO;
//        }
//    }
//    //点击手势
//    else {
//        //点击手势过滤子视图的方法
//        if([touch.view isDescendantOfView:self.mainScrollView]) {
//            return NO;
//        }
//    }
//    return YES;
//}

- (void)testAction {
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:[[SlideCloseTestViewController alloc]init]];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:vc animated:YES completion:nil];
}
@end
