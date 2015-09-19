//
//  ViewController.m
//  Objective-C消息发送和消息转发机制的实现
//
//  Created by yifan on 15/9/19.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"
#import "PersonModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonModel *personModel = [[PersonModel alloc] init];
    
    //    //消息转发  resolveInstanceMethod
    personModel.name = @"Jim Green";
    NSString *name = personModel.name;
    NSLog(@"%@", name);
    //消息转发 forwardingTargetForSelector
    NSString *name1 = [personModel companyName];
    NSLog(@"%@", name1);
    //    //消息转发 forwardInvocation
    NSString *name2 = [personModel deptName];
    NSLog(@"%@", name2);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
