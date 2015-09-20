//
//  HCDPropertyType.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "HCDPropertyType.h"

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
        
        NSLog(@"%@",type);
    }
    return self;
}@end
