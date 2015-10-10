//
//  HCDObservationInfo.h
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/10.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HCDObservingBlock)(id observerObject,NSString *observedKey, id oldValue, id newValue);

@interface HCDObservationInfo : NSObject
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) HCDObservingBlock block;

- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(HCDObservingBlock)block;
@end
