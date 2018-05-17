//
//  MessageInterface.m
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2017/5/5.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "MessageInterface.h"
#import "EAMMessageListViewController.h"
#import <FFIMKit/FFIMKit-umbrella.h>

@interface MessageInterface()<EABTabIconDelegate>

@end

@implementation MessageInterface

+(void)load{
    [[EABTabLoadContext sharedInstance]RegisterSubViewController:[self class]];
}


#pragma mark -- EABTabIconDelegate
-(NSDictionary*)itemOfTabViewController{
    return @{@"title":@"消息", // 必选
             @"index":@0, // 必选 index 从0开始
             @"imageNomal":@"", // 必选
             @"imageHightlight":@"", // 必选
             @"viewController":[[EAMMessageListViewController alloc]init] // 必选
             };
}

+(UIViewController*)getVc{
    return [[EAMMessageListViewController alloc]init];
}
@end