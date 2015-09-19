//
//  CompanyModel.m
//  Objective-C消息发送和消息转发机制的实现
//
//  Created by yifan on 15/9/19.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel
- (NSString *)companyName{
    
    return @"测试公司";
}

- (NSString *)deptName:(BOOL)isWithCompanyName{
    if (isWithCompanyName) {
        return @"测试公司研发部门";
    }else{
        return @"研发部门";
    }
}
@end
