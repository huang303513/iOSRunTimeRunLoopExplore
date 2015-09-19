//
//  PersonModel.h
//  Objective-C消息发送和消息转发机制的实现
//
//  Created by yifan on 15/9/19.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CompanyModel;
@interface PersonModel : NSObject
@property(nonatomic, copy)NSString *firstName;
@property(nonatomic, copy)NSString *lastName;
//这个属性在实现文件里面设置为动态属性、所以并不会生成get和set方法
@property(nonatomic, copy)NSString *name;
//这两个方法根本就没有实现
- (NSString *)companyName;
- (NSString *)deptName;
@end
