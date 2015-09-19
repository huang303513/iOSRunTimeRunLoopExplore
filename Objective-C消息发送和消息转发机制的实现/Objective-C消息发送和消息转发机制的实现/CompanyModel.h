//
//  CompanyModel.h
//  Objective-C消息发送和消息转发机制的实现
//
//  Created by yifan on 15/9/19.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  这个类的作用主要用于实现PersonModel没有实现的方法，用于接收消息转发
 */
@interface CompanyModel : NSObject

- (NSString *)companyName;

- (NSString *)deptName:(BOOL)isWithCompanyName;
@end
