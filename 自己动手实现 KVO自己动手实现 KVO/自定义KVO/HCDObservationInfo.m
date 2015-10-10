//
//  HCDObservationInfo.m
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/10.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "HCDObservationInfo.h"

@implementation HCDObservationInfo
- (instancetype)initWithObserver:(NSObject *)observer Key:(NSString *)key block:(HCDObservingBlock)block
{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}
@end
