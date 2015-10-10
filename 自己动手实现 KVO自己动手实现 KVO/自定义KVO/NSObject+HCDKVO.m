//
//  NSObject+HCDKVO.m
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/8.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "NSObject+HCDKVO.h"
#import "HCDObservationInfo.h"
#import <objc/runtime.h>
#import <objc/message.h>
/**
 *  创建的KVO类的前缀
 */
NSString *const kHCDKVOClassPrefix = @"HCDKVOClassPrefix_";
NSString *const kHCDKVOAssociatedObservers = @"HCDKVOAssociatedObservers";

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

/**
 *  通过传入一个setter方法，返回对应的getter方法
 *
 *  @param setter setter方法名字
 *
 *  @return 返回getter方法
 */
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    //通过setter得到对应的getter
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}


/**
 *  重写KVO类的setter方法
 *
 *  @param self     类名
 *  @param _cmd     setter名字
 *  @param newValue setter对应属性的新值
 */
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"对象 %@ 没有setter方法 %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // 对 objc_msgSendSuper 进行类型转换。在 Xcode 6 里，新的 LLVM 会对 objc_msgSendSuper 以及 objc_msgSend 做严格的类型检查，如果不做类型转换。Xcode 会抱怨有 too many arguments 的错误。
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    

    //调用原始类的setter方法。实现真正的改变属性值
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    //遍历这个对象的观察者对象，如果属性名字和each的观察属性相同。则调用回调block。
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kHCDKVOAssociatedObservers));
    for (HCDObservationInfo *each in observers) {
        if ([each.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                each.block(self, getterName, oldValue, newValue);
            });
        }
    }
}




/**
 *  得到父类
 *
 *  @param self 对象
 *  @param _cmd 方法
 *
 *  @return 返回父类
 */
static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}


@implementation NSObject (HCDKVO)
-(void)HCD_addobserver:(NSObject *)observer forkey:(NSString *)key withBlock:(HCDObservingBlock)block{
    //1如果这个类或者父类没有实现指定属性的setter方法，抛出异常
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    //NSAssert(!setterMethod, @"没有对应的setter方法");
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"对象 %@ 没有key %@的setter方法", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    //2 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
    if (![clazzName hasPrefix:kHCDKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        object_setClass(self, clazz);//把这个类设置为clazz类，这里就实现了系统kvo的替换类类型的步骤
    }
    
    //3检查对象的 KVO 类重写过没有这个 setter 方法。如果没有，添加重写的 setter 方法；
    if (![self hasSelector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
         class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
    }
    
    //4添加这个观察者
    HCDObservationInfo *info = [[HCDObservationInfo alloc]initWithObserver:observer Key:key block:block];
    //把HCDObservationInfo对象添加到这个对象的观察对象列表里面。
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kHCDKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(kHCDKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
    
    
}

/**
 *  移除这个对象自定义的观察者
 *
 *  @param observer 观察者对象
 *  @param key      观察者观察的key
 */
-(void)HCD_removeObserver:(NSObject *)observer forkey:(NSString *)key{
    //通过关联对象得到观察者列表
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(kHCDKVOAssociatedObservers));
    
    HCDObservationInfo *infoToRemove;
    for (HCDObservationInfo* info in observers) {
        //如果观察者对象和key都符合要移除的对象
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    
    [observers removeObject:infoToRemove];

}

/**
 *  为一个指定的类创建一个对应与系统的KVO类，用于实现KVO功能。
 *
 *  @param originalClassName 原始类的名字
 *
 *  @return 对应的KVO类的名字
 */
-(Class )makeKvoClassWithOriginalClassName:(NSString  *)originalClassName{
    //对应的kvo类的名字
    NSString *kvoClassName = [kHCDKVOClassPrefix stringByAppendingString:originalClassName];
    Class clazz = NSClassFromString(kvoClassName);
    if (clazz) {//如果运行时系统中有此类了，则直接返回这个类
        return clazz;
    }
    //新建一个类
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClassName.UTF8String, 0);//传一个父类，类名，然后额外的空间（通常为 0），它返回给你一个类。
    
    //通过originalClazz的内存结构构件一个名字叫kvoClassName类的内存结构和方法等等
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));//得到原始类的class方法
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);//重写class方法
    objc_registerClassPair(kvoClazz);//把kvo类注册到运行时
    
    return kvoClazz;
}

/**
 *  判断一个类是否有某个方法
 *
 *  @param selector 方法名字
 *
 *  @return 返回yes  no
 */
- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    
    free(methodList);
    return NO;
}
@end
