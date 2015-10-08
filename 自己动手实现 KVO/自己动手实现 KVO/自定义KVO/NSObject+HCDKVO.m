//
//  NSObject+HCDKVO.m
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/8.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "NSObject+HCDKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kPGKVOClassPrefix = @"PGKVOClassPrefix_";
NSString *const kPGKVOAssociatedObservers = @"PGKVOAssociatedObservers";

/**
 *  把setter方法转换为getter方法
 *
 *  @param getter getter方法
 *
 *  @return 返回对应的setter方法
 */
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // 把getter方法的第一个字母大写
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // 添加‘set’和':'
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}


@implementation NSObject (HCDKVO)
-(void)HCD_addobserver:(NSObject *)observer forkey:(NSString *)key withBlock:(HCDObservingBlock)block{
    //1如果这个类或者父类没有实现指定属性的setter方法，抛出异常
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    NSAssert(!setterMethod, @"没有对应的setter方法");
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    //2 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
//    if ([clazzName hasPrefix:<#(nonnull NSString *)#>]) {
//        <#statements#>
//    }
    
    
    
}
@end
