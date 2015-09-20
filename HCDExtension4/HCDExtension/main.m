//
//  main.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#warning 博文参考地址：http://www.jianshu.com/p/d2ecef03f19e

#import <Foundation/Foundation.h>
#import "HCDUser.h"
#import "NSObject+Property.h"
#import "NSObject+HCDKeyValueObject.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
//        NSDictionary *dict = @{
//                               @"name" : @"Jack",
//                               @"icon" : @"lufy.png",
//                               @"age" : @"20",
//                               @"height" : @1.55,
//                               @"money" : @"100.9",
//                               @"sex" : @(SexFemale),
//                               @"gay" : @"true",
//                               };
//        HCDUser *user = [HCDUser objectWithKeyValues:dict];
        
         NSString *jsonString = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";
        HCDUser *user = [HCDUser objectWithKeyValues:jsonString];
        
        NSLog(@"name=%@, icon=%@, age=%zd, height=%@, money=%@, sex=%d, gay=%d", user.name, user.icon, user.age, user.height, user.money, user.sex, user.gay);
    }
    return 0;
}
