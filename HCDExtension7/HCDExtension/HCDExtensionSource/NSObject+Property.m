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
#import "HCDPropertyType.h"
/**
 *  次结构体是一个属性列表的对象
 */
typedef struct property_t {
    const char *name;
    const char *attributes;
} *propertyStruct;

@implementation NSObject (Property)

static NSSet *foundationClasses_;

+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)c{
    if (c == [NSObject class]) return YES;
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


+(NSArray *)properties{
    NSArray *propertiesArray = [NSMutableArray array];
    //1 获取所有的属性
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        HCDProperty *propertyObj = [HCDProperty propertyWithProperty:property];
        [((NSMutableArray *)propertiesArray) addObject:propertyObj];
        //NSLog(@"%@,%@",propertyObj.name,propertyObj.type.typeClass);
    }
    
    return propertiesArray;
}
@end

