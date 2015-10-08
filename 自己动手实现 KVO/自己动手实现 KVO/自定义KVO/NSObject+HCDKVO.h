//
//  NSObject+HCDKVO.h
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/8.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HCDObservingBlock)(id observerObject,NSString *observedKey, id oldValue, id newValue);

@interface NSObject (HCDKVO)

-(void)HCD_addobserver:(NSObject *)observer forkey:(NSString *)key withBlock:(HCDObservingBlock)block;
-(void)HCD_removeObserver:(NSObject *)observer forkey:(NSString *)key;

@end
