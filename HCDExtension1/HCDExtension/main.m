//
//  main.m
//  HCDExtension
//
//  Created by 黄成都 on 15/9/20.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDUser.h"
#import "NSObject+Property.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSArray *propertyArray = [HCDUser properties];
        NSLog(@"%@",propertyArray);
    }
    return 0;
}
