//
//  SystemParam.m
//  edu_anhui_util
//
//  Created by yangjuanping on 2017/5/25.
//
//

#import "SystemParam.h"
#import "sys/utsname.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//CGFloat fMainWidth;
//CGFloat fMainHeight;

@interface SystemParam()

@end

static E_PLATFORM iPhonePlatform;
static E_IOS_VERSION iosVersion;

static float fMainWidth;
static float fMainHeight;



@implementation SystemParam

+(void)load{
    iPhonePlatform = [SystemParam getPatform];
    iosVersion = [SystemParam getVersion];
    fMainWidth = [UIScreen mainScreen].bounds.size.width;
    fMainHeight = [UIScreen mainScreen].bounds.size.height;
}

+(E_PLATFORM)getPatform{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) return E_PLATFORM_4;
    else if ([platform isEqualToString:@"iPhone4,1"]) return E_PLATFORM_4S;
    else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) return E_PLATFORM_5;
    else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) return E_PLATFORM_5C;
    else if ([platform isEqualToString:@"iPhone6,1"]||[platform isEqualToString:@"iPhone6,2"]) return E_PLATFORM_5S;
    else if ([platform isEqualToString:@"iPhone7,1"]) return E_PLATFORM_6P;
    else if ([platform isEqualToString:@"iPhone7,2"]) return E_PLATFORM_6;
    else if ([platform isEqualToString:@"iPhone8,1"]) return E_PLATFORM_6S;
    else if ([platform isEqualToString:@"iPhone8,2"]) return E_PLATFORM_6SP;
    else if ([platform isEqualToString:@"iPhone8,4"]) return E_PLATFORM_SE;
    else{
        return E_PLATFORM_6;
    }
}

+(E_IOS_VERSION)getVersion{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>=11.0) {
        return E_IOS_VERSION11;
    }
    else if (version>=10.0){
        return E_IOS_VERSION10;
    }
    else if (version>=9.0){
        return E_IOS_VERSION9;
    }
    else if (version>=8.0){
        return E_IOS_VERSION8;
    }
    else if (version>=7.0){
        return E_IOS_VERSION7;
    }
    else{
        return E_IOS_VERSION_OTHER;
    }
}

+(E_PLATFORM)systemPlatform{
    return iPhonePlatform;
}

+(E_IOS_VERSION)iosVersion{
    return iosVersion;
}

+(float)mainWidth{
    return fMainWidth;
}

+(float)mainHeight{
    return fMainHeight;
}

@end
