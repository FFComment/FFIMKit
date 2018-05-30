//
//  FFViewController.m
//  FFIMKit
//
//  Created by 2305710307@qq.com on 05/16/2018.
//  Copyright (c) 2018 2305710307@qq.com. All rights reserved.
//

#import "FFViewController.h"
#import <FFIMKit/FFIMKit-umbrella.h>
#import "FFAppDelegate.h"

@interface FFViewController () <EAMMesageChatVCDelegate>

@property (nonatomic, strong) EAMMesageChatVC         *messageChatVC;

@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpUI];
    self.messageChatVC = [[EAMMesageChatVC alloc]init];
    UIApplication *application = [UIApplication sharedApplication];
    FFAppDelegate *app = (FFAppDelegate *)application.delegate;
    app.m_allMessagesCallback = ^(id result, id error) {

        if([result isKindOfClass:[VwtIMMessage class]]){//vwt提供的im通道消息
            NSLog(@"VwtIMMessage-->%@",@"im通道消息");

        }else if([result isKindOfClass:[VwtServicePush class]]){//vwt提供的push通道消息
            NSLog(@"VwtServicePush-->%@",@"push通道消息");

        }else if([result isKindOfClass:[VwtError class]]){
            VwtError *vwtRet = (VwtError *)result;
            if(vwtRet.code == VWT_LOGIN_SUCCESS){//登录(重连)成功,获取离线消息
                NSLog(@"MessagesCallback-->%@",@"登录成功");
                //[self getOfflineMsg];
            }else if (vwtRet.code == VWT_KICKED_OUT){//被踢

            }else if (vwtRet.code == VWT_NOT_LOGIN){//你尚未登录,请先登录

            }else{//一分钟后尝试重连

            }
        }else if([result isKindOfClass:[NSDictionary class]]){//点击通知栏获取到的数据,可根据需要处理


        }else{

        }
    };
    
}

/**  设置UI */
- (void)setUpUI {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"聊天" forState:UIControlStateNormal];
    [btn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)pushVC:(UIButton *)sender {
//    self.messageChatVC = [[EAMMesageChatVC alloc]init];
    self.messageChatVC.delegate = self;
    self.messageChatVC.title = @"聊天";
    [self presentViewController:self.messageChatVC animated:YES completion:nil];
    [self connect:@"600052265" withDeviceId:@"600052265"];
}

// 登录
- (void)connect:(NSString *)userId withDeviceId:(NSString *)deviceId
{
    UIApplication *application = [UIApplication sharedApplication];
    FFAppDelegate *app = (FFAppDelegate *)application.delegate;
    [app initAndAsync:userId
         withDeviceId:deviceId
         withCallBack:^(id result, id error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if(result){
                     NSLog(@"登陆成功");
                 }else{
                     NSLog(@"登陆失败");
                 }
             });
             
         }];
}
#pragma mark --
#pragma mark -- EAMMesageChatVCDelegate
- (void)chatVCSendMessage:(NSString *)message {
    NSLog(@"今天天气就是这么好");
    [getAppDelegate() sendMessage:message
                         TargetId:@"10000007"
                      MessageType:VwtMessageTypeText
             andWithExtendedField:nil
                          success:^(id value) {
                              NSLog(@"单聊发送成功---:%@",value);
                              
                          } error:^(VwtError *error) {
                              NSLog(@"单聊发送失败---:%@",error.content);
                              
                          }];
}
- (void)chatVCRecordingVoice {
    NSLog(@"这是录音啊");
}
@end
