//
//  NSObject+HCDKeyValueObject.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "NSObject+HCDKeyValueObject.h"
#import "NSObject+Property.h"
#import "HCDProperty.h"
#import "HCDPropertyType.h"
@implementation NSObject (HCDKeyValueObject)
+ (instancetype)objectWithKeyValues:(id)keyValues{
    if (!keyValues) return nil;
    return [[[self alloc] init] setKeyValues:keyValues];
}


- (instancetype)setKeyValues:(id)keyValues{
    keyValues = [keyValues JSONObject];
    NSArray *propertiesArray = [self.class properties];
    for (HCDProperty *property in propertiesArray) {
        HCDPropertyType *type = property.type;
        Class typeClass = type.typeClass;
        
        id value = [keyValues valueForKey:property.name];
        if (!value) continue;
        
        
        if (type.isNumberType){
            NSString *oldValue = value;
            // 字符串->数字
            if ([value isKindOfClass:[NSString class]]){
                value = [[[NSNumberFormatter alloc] init] numberFromString:value];
                if (type.isBoolType) {
                    NSString *lower = [oldValue lowercaseString];
                    if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"true"] ) {
                        value = @YES;
                    } else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"]) {
                        value = @NO;
                    }
                }
            }
        }
        else{
            if (typeClass == [NSString class]) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    if (type.isNumberType)
                        // NSNumber -> NSString
                        value = [value description];
                }else if ([value isKindOfClass:[NSURL class]]){
                    // NSURL -> NSString
                    value = [value absoluteString];
                }
            }
        }
        [self setValue:value forKey:property.name];
    }
    return self;
}
/**
 *  传入一个nsstring或者nsdata对象，返回对应的json数据。
 *
 *  @return <#return value description#>
 */
- (id)JSONObject{
    id foundationObj;
    if ([self isKindOfClass:[NSString class]]) {
        foundationObj = [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }else if ([self isKindOfClass:[NSData class]]){
        foundationObj = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    return foundationObj?:self;
}

@end
