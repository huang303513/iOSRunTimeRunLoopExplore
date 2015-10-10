//
//  ViewController.m
//  自己动手实现 KVO
//
//  Created by yifan on 15/10/8.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HCDKVO.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    __weak UITextField *weakTextField = self.textField;
    [self.textField HCD_addobserver:self forkey:NSStringFromSelector(@selector(text)) withBlock:^(id observerObject, NSString *observedKey, id oldValue, id newValue) {
        NSLog(@"%@.%@ is now: %@", observerObject, observedKey, newValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakTextField.text = newValue;
        });

    }];
    
    
    [self changeClick:nil];


}


- (IBAction)changeClick:(id)sender {
    
    NSArray *msgs = @[@"Hello World!", @"Objective C", @"Swift", @"Peng Gu", @"peng.gu@me.com", @"www.gupeng.me", @"glowing.com"];
    NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
    self.textField.text = msgs[index];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
