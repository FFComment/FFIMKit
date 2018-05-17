//
//  FFViewController.m
//  FFIMKit
//
//  Created by 2305710307@qq.com on 05/16/2018.
//  Copyright (c) 2018 2305710307@qq.com. All rights reserved.
//

#import "FFViewController.h"
#import <FFIMKit/FFIMKit-umbrella.h>

@interface FFViewController ()

@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 100);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"聊天" forState:UIControlStateNormal];
    [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)pushVC:(UIButton *)sender {
    EAMMesageChatVC* vc = [[EAMMesageChatVC alloc]init];
    vc.title = @"聊天";
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
