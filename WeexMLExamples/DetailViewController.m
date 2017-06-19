//
//  DetailViewController.m
//  123
//
//  Created by yinfeng on 2017/6/12.
//  Copyright © 2017年 yinfeng. All rights reserved.
//

#import "DetailViewController.h"
#import <WeexSDK/WeexSDK.h>

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    WXSDKInstance *_instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self renderWeex];
}

- (void)renderWeex
{
    _instance = [WXSDKInstance new];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.view addSubview:view];
    };
    NSString *randomURL = [NSString stringWithFormat:@"%@%@random=%d", self.url, @"?",arc4random()];
    [_instance renderWithURL:[NSURL URLWithString:randomURL] options:nil data:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
