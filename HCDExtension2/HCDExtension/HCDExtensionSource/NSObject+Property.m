//
//  NSObject+Property.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>
#import "HCDProperty.h"
/**
 *  次结构体是一个属性列表的对象
 */
typedef struct property_t {
    const char *name;
    const char *attributes;
} *propertyStruct;

@implementation NSObject (Property)
+(NSArray *)properties{
    NSArray *propertiesArray = [NSMutableArray array];
    //1 获取所有的属性
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    
//    for (int i = 0; i < outCount; i++) {
//        //去除一条属性
//        objc_property_t  property  = properties[i];
//        //属性名
//        NSString *name = @(property_getName(property));
//        //得到属性的各种信息
//        NSString *attributes = @(property_getAttributes(property));
//        NSUInteger loc = 1;
//        NSUInteger len = [attributes rangeOfString:@","].location - loc;
//        NSString *type = [attributes substringWithRange:NSMakeRange(loc, len)];
//        NSLog(@"name:%s---attributes:%s",property_getName(property),
//              property_getAttributes(property));
//        NSLog(@"name:%s---attributes:%s",((propertyStruct)property)->name,((propertyStruct)property)->attributes);
//        NSLog(@"%@",type);
//
//    }
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        HCDProperty *propertyObj = [HCDProperty propertyWithProperty:property];
        [((NSMutableArray *)propertiesArray) addObject:propertyObj];
    }
    
    return propertiesArray;
}
@end

