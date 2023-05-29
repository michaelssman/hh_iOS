//
//  HHOperation.m
//  HHMultiThread
//
//  Created by michael on 2021/10/20.
//  Copyright © 2021 michael. All rights reserved.
//

#import "HHOperation.h"
/**
 在iOS中使用线程主要是GCD，和NSOperation 两种方式。
 GCD 对线程依赖，线程取消支持的不是很好，所以如果有这方面的需求果断使用NSOperation 。
 NSOperation是个抽象方法，并不能直接使用，主要使用NSBlockOperation 和 NSInvocationOperation 两个子类来完成任务。当然也可以使用NSOperation的子类。
 自定义NSOperation 要实现start() isReady(),isExecuting(),isFinished(),isConcurrent()方法，让系统知道线程的状态如果不重写这些方法系统会不知道线程的状态，不能完成响应的操作。
 如果不重写isFinish()方法，completeBlock 将不会调用，因为系统并不知道线程状态已经结束。
 工作任务写在start方法中。新建好SubOperation之后 可以直接添加到NSOperationQueue中，线程自动执行。当然也可以调用start()方法.。
 */

/**
 在ios4以前，只有非并发的情况下，队列会为operation开启一个线程来执行。如果是并发的情况，operation需要自己创建一个线程来执行。所以说，NSoperation的并发和非并发不是传统意义上的串行和并行。

 但是在ios4以后，不管是并发还是非并发，队列都会为operation提供一个线程来执行。所以isConcurrent这个变量也就没有用处了。

 但是，这里还设涉及到了两个方法，start和main.

 按照官方文档所说，如果是非并发就使用main，并发就使用start。

 那现在并发和非并发已经没有区别了，start和main的区别在哪里呢？

 main方法的话，如果main方法执行完毕，那么整个operation就会从队列中被移除。如果你是一个自定义的operation并且它是某些类的代理，这些类恰好有异步方法，这是就会找不到代理导致程序出错了。

 然而start方法就算执行完毕，它的finish属性也不会变，因此你可以控制这个operation的生命周期了。

 然后在任务完成之后手动cancel掉这个operation即可。
 */
@implementation HHOperation
/**
 执行完就 从队列中移除了
 自定义的Operation中只有实现main方法才会开启线程处理任务
 */
- (void)main {
}

/// 执行完不会移除，手动cancel
- (void)start {
    int index = 0 ;
    while (index < 5) {
        self.state = AFOperationExecutingState ;
        sleep(1);
        index += 1;
    }
    self.state = AFOperationFinishedState;
}

- (BOOL)isReady {
    return self.state == AFOperationReadyState && [super isReady];
}
- (BOOL)isExecuting {
    return self.state == AFOperationExecutingState;
}
- (BOOL)isFinished {
    return self.state == AFOperationFinishedState;
}
- (BOOL)isConcurrent {
    return YES;
}
@end
