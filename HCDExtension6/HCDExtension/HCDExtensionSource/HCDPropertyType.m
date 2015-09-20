//
//  HCDPropertyType.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "HCDPropertyType.h"
#import "HCDExtensionConst.h"
#import "HCDProperty.h"
#import "NSObject+Property.h"
@implementation HCDPropertyType
+ (instancetype)propertyTypeWithAttributeString:(NSString *)string{
    return [[HCDPropertyType alloc] initWithTypeString:string];
}

- (instancetype)initWithTypeString:(NSString *)string
{
    if (self = [super init])
    {
        NSUInteger loc = 1;
        NSUInteger len = [string rangeOfString:@","].location - loc;
        NSString *type = [string substringWithRange:NSMakeRange(loc, len)];
        [self getTypeCode:type];
       // NSLog(@"%@",type);
    }
    return self;
}
/**
 *  得到具体的类型
 *
 *  @param code 得到具体的类型信息
 */
- (void)getTypeCode:(NSString *)code
{
    if ([code isEqualToString:MJPropertyTypeId]) {
        _idType = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _numberType = (_typeClass == [NSNumber class] || [_typeClass isSubclassOfClass:[NSNumber class]]);
        //
        _fromFoundation = [NSObject isClassFromFoundation:_typeClass];
    }
    // 是否为数字类型
    NSString *lowerCode = code.lowercaseString;
    NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeChar];
    //boole类型是number类型的一种。
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:MJPropertyTypeBOOL1]
            || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}

@end
