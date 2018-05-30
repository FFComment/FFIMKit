//
//  SystemParam.h
//  edu_anhui_util
//
//  Created by yangjuanping on 2017/5/25.
//
//

#import <Foundation/Foundation.h>

// 屏幕高
#define  MAIN_HEIGHT                  [SystemParam mainHeight]

// 屏幕宽
#define  MAIN_WIDTH                   [SystemParam mainWidth]

// 手机型号枚举
typedef NS_ENUM(NSInteger, E_PLATFORM){
    E_PLATFORM_4=0,
    E_PLATFORM_4S,
    E_PLATFORM_5,
    E_PLATFORM_5C,
    E_PLATFORM_5S,
    E_PLATFORM_6,
    E_PLATFORM_6P,
    E_PLATFORM_SE,
    E_PLATFORM_6S,
    E_PLATFORM_6SP,
    E_PLATFORM_7,
    E_PLATFORM_7P,
};

typedef NS_ENUM(NSInteger, eScreenSize){
    eScreenSize4=0,
    eScreenSize5,
    eScreenSize6
};

// 操作系统版本号枚举
typedef NS_ENUM(NSInteger, E_IOS_VERSION){
    E_IOS_VERSION_OTHER = -1,
    E_IOS_VERSION7=0,
    E_IOS_VERSION8,
    E_IOS_VERSION9,
    E_IOS_VERSION10,
    E_IOS_VERSION11,
};


@interface SystemParam : NSObject

+(E_PLATFORM)systemPlatform;

+(E_IOS_VERSION)iosVersion;

+(float)mainWidth;

+(float)mainHeight;

@end
