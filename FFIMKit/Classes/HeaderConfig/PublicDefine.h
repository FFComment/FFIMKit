//
//  PublicDefine.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/10.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#ifndef PublicDefine_h
#define PublicDefine_h


#pragma mark 获取当前屏幕的宽度、高度
//宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#pragma mark 导航条的高度
//导航条高度
#define kNavBarHeight 64.0
//标签栏的高度
#define kTabBarHeight 49.0
//导航条title的font
#define kNavTitleFont UIFont_size(18.0)
//标签栏item的font
#define kTabBarItemFont UIFont_size(11.0)
//选项卡的高度
#define tabsHeight 45.0
//预定义圆角数
#define kAppMainCornerRadius 4.0

#define ChatEmojiView_Hight    210.0f //表情View的高度
#define keyboardHeight         258.0f
#define ChatEmojiView_Bottom_H 40.0f
#define ChatEmojiView_Bottom_W 52.0f



#pragma mark 字体相关
//字体
#define   FONT_SIZE 14
#define   MAX_NUM_INPUTCHAR         500//最多输入的字符数
#define   MAX_IMAGE_WH   141.0
#define   MAX_LENGTH_CHAT_CELL          (MAIN_WIDTH-140)  //聊天界面cell的最大宽度
#define   UIFont_size(size) [UIFont systemFontOfSize:size]
#define   UIFont_bold_Size(size) [UIFont boldSystemFontOfSize:size]
#define   WEAKSELF typeof(self) __weak weakSelf = self;
#define   STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define   IMAGENAMED(NAME)       [UIImage imageNamed:NAME]



#pragma mark - Dev
//Log
#ifdef DEBUG
#define DLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(xx, ...)  ((void)0)
#endif


#define KEY_SELECTED_YEAR  @"KEY_SELECTED_YEAR"
#define KEY_SELECTED_MONTH @"KEY_SELECTED_MONTH"
#define KEY_SELECTED_DAY @"KEY_SELECTED_DAY"

#define KEY_REFRESH_CHAT_NUM          @"KEY_REFRESH_CHAT_NUM"
#define KEY_IS_OUTDEATE_TOKEN         @"KEY_IS_OUTDEATE_TOKEN"

#define KEY_UPLOAD_SCORE              @"KEY_UPLOAD_SCORE"
#define KEY_NAME_SUBJECT              @"KEY_NAME_SUBJECT"

#define KEY_REMOTEID                   @"KEY_REMOTEID"
#define KEY_LOGINID_IMTOKEN            @"KEY_LOGINID_IMTOKEN"
#define BAIDUMAP_STATIC_SNAP(longitude,latitude) [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@&width=120&height=80&zoom=12&&markers=%@,%@&markerStyles=-1,http://api.map.baidu.com/images/marker_red.png,-1",longitude,latitude,longitude,latitude]
#define KEY_SCHOOLTYPE                 @"KEY_SCHOOLTYPE"
#define KEY_ORGIN

#define REGEX_KEY                     @"\\(#\\w*\\)"// @"\\[[\u4e00-\u9fa5]*\\]"
#define REGEX_EMOJI                   @"\\(#\\w*\\)|\\[#\\w*\\]" //替换查找(#xxx)格式的字符串 \(#[\u4e00-\u9fa5]*\)
#define REGEX_EMOJI_JS                @"\\[#\\w*\\]"
#define REGEX_WEB                     @"\\[\\w*\\]"
#define SEPARATE_EMOJI                @"!-!-+"//用于分离含有emoji字符串的内容转化,便于输出在SETextView中
#define OBJECT_REPLACEMENT_CHAR       "\xef\xbf\xbc" //占位符

#pragma mark 颜色相关
//颜色
#define UICOLOR_FROM_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kAppBlackColor [UIColor blackColor]         //黑色
#define kAppGrayColor [UIColor grayColor]           //灰色
#define kAppDarkGrayColor [UIColor darkGrayColor]   //深灰色
#define kAppLightGrayColor [UIColor lightGrayColor] //浅灰色
#define kAppWhiteColor [UIColor whiteColor]         //白色
#define kAppRedColor [UIColor redColor]             //红色
#define kAppOrangeColor [UIColor orangeColor]       //橙色
#define kAppClearColor [UIColor clearColor]         //透明色
#define kAppDarkTextColor [UIColor darkTextColor]
#define kAppLightTextColor [UIColor lightTextColor]
#define kAppLineColor UICOLOR_FROM_RGB(229,229,229,1)//细线的颜色
#define kAppMainBgColor UICOLOR_FROM_RGB(240,240,240,1)

//本软件主色调
#define kAppMainBrownColor UICOLOR_FROM_RGB(53,48,43,1)
#define kAppMainLightBrownColor UICOLOR_FROM_RGB(118,108,96,1)
#define kAppMainOrangeColor UICOLOR_FROM_RGB(252,142,6,1)
#define kAppMainDarkGrayColor UICOLOR_FROM_RGB(105,105,105,1)
#define   RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


#define SINGLETON_FOR_HEADER(className) \
+ (className *)sharedInstance;

//单例实现的公用函数
#define SINGLETON_FOR_CLASS(className) \
+ (className *)sharedInstance { \
static className *shared = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
}

#define FONT_MEDIUM @"PingFangSC-Medium"
#define FONT_REGULAR @"PingFangSC-Regular"
#define FONT_SEMIBOLD @"PingFangSC-Semibold"
#define FONT_SC @"PingFangSC"

#endif /* PublicDefine_h */
