//
//  UIViewController+IMPCategory.m
//  IMP指针的作用
//
//  Created by yifan on 15/9/29.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "UIViewController+IMPCategory.h"
#import "objc/runtime.h"

typedef void (*_VIMP)(id,SEL, ...);//返回类型为空
typedef id (*_IMP)(id,SEL, ...);//有返回类型

@implementation UIViewController (IMPCategory)
//====================第一种实现================
//+(void)load{
//    //保证交换方法只执行一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//       //获取到这个累得viewDidLoad方法，他的类型是一个objc_method结构体指针
//        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
//        //获取自己刚刚新建的一个方法
//        Method viewDidLoaded = class_getInstanceMethod(self, @selector(viewDidLoaded));
//        //交换两个方法的实现
//        method_exchangeImplementations(viewDidLoad, viewDidLoaded);
//    });
//}
//
////新建一个方法与ViewDidLoad交换实现
//-(void)viewDidLoaded{
//    //调用系统原有的方法
//    [self viewDidLoaded];
//    NSLog(@"%@ did load",self);
//}
//========================第二种实现===============================
+(void)load{
    //保证交换方法只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取到这个累得viewDidLoad方法，他的类型是一个objc_method结构体指针
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        //获取方法实现,因为我们要实现的viewDidLoad方法是返回为void的类型。所以我们需要用_VIMP
        _VIMP viewDidLaod_IMP = (_VIMP)method_getImplementation(viewDidLoad);
        //重新设置实现
        method_setImplementation(viewDidLoad, imp_implementationWithBlock(^(id target, SEL action){
            viewDidLaod_IMP(target,@selector(viewDidLoad));
            //新增代码
            NSLog(@"%@ did load",target);
        }));
    });
 
}

@end
