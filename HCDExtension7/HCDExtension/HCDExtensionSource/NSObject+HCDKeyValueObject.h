//
//  NSObject+HCDKeyValueObject.h
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCDKeyValue <NSObject>
@optional
/**
 *  用于指定一个数组中元素的类型
 *
 *  @return 返回一个字典，值表示对应的类型
 */
+ (NSDictionary *) objectClassInArray;
/**
 *  把一些属性值替换为指定的Key
 *
 *  @return 返回一个对应的字典
 */
//+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (HCDKeyValueObject)<HCDKeyValue>
/**
 *  返回解析的实例对象
 *
 *  @param keyValues 传入一个字典字典
 *
 *  @return 返回一个解析好的实例对象
 */
+ (instancetype)objectWithKeyValues:(id)keyValues;

@end
