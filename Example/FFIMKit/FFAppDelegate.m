//
//  FFAppDelegate.m
//  FFIMKit
//
//  Created by 2305710307@qq.com on 05/16/2018.
//  Copyright (c) 2018 2305710307@qq.com. All rights reserved.
//

#import "FFAppDelegate.h"

@implementation FFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.m_allMessagesCallback = ^(id result, id error) {
        
        if([result isKindOfClass:[VwtIMMessage class]]){//vwt提供的im通道消息
            
            
        }else if([result isKindOfClass:[VwtServicePush class]]){//vwt提供的push通道消息
            
            
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
    
    
//    return YES;
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [super application:app didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
@end
