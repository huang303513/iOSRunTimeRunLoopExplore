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
#import "HCDStatus.h"
#pragma mark --函数声明
void execute(void (*fun)());
void keyValue2object();
void keyValues2object1();
void keyValues2object2();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        
//         NSString *jsonString = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";
//        HCDUser *user = [HCDUser objectWithKeyValues:jsonString];
//        
//        NSLog(@"name=%@, icon=%@, age=%zd, height=%@, money=%@, sex=%d, gay=%d", user.name, user.icon, user.age, user.height, user.money, user.sex, user.gay);
        
        
        execute(keyValues2object2);
    }
    return 0;
}

void execute(void (*fun)()){
    fun();
    return;
}

/**
 *  复杂的字典 -> 模型 (模型里面包含了模型)
 */
void keyValues2object2()
{
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"text" : @"是啊，今天天气确实不错！",
                           
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           
                           @"retweetedHCDStatus" : @{
                                   @"text" : @"今天天气真不错！",
                                   
                                   @"user" : @{
                                           @"name" : @"Rose",
                                           @"icon" : @"nami.png"
                                           }
                                   }
                           };
    
    // 2.将字典转为HCDStatus模型
    HCDStatus *status = [HCDStatus objectWithKeyValues:dict];
    
    // 3.打印HCDStatus的属性
    NSString *text = status.text;
    NSString *name = status.user.name;
    NSString *icon = status.user.icon;
    NSLog(@"text=%@, name=%@, icon=%@", text, name, icon);
    
    // 4.打印status.retweetedStatus的属性
    NSString *text2 = status.retweetedHCDStatus.text;
    NSString *name2 = status.retweetedHCDStatus.user.name;
    NSString *icon2 = status.retweetedHCDStatus.user.icon;
    NSLog(@"text2=%@, name2=%@, icon2=%@", text2, name2, icon2);

}

