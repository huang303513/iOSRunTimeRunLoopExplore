//
//  NSObject+HCDKeyValueObject.h
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HCDKeyValueObject)
/**
 *  返回解析的实例对象
 *
 *  @param keyValues 传入一个字典字典
 *
 *  @return 返回一个解析好的实例对象
 */
+ (instancetype)objectWithKeyValues:(id)keyValues;

@end
