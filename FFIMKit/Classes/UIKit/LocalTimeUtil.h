//
//  LocalTimeUtil.h
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTimeUtil : NSObject

+ (NSDate *)dateFrom:(NSString *)time;

+ (BOOL)isTodayWith:(NSString *)dayTime;

+ (NSString *)getCurrentTime;

//转化服务器时间(格林威治时间)
+ (NSString *)getLocalTimeWith:(NSString *)serverTime;

//转化服务器时间(格林威治时间)
+ (NSString *)getLocalTimeWithNormal:(NSString *)tcpTime;

+ (NSString *)getFinalTime:(NSString *)time;

//系统时间转化为时间戳
+ (NSString *)getTimestamp;

+ (BOOL)isToday:(NSString *)time;

+ (BOOL)isYesterday:(NSString *)time;

+ (BOOL)isShowTimeLabel:(NSString *)time belongToTime:(NSString **)belong;

+ (NSString *)getCurrentMonth;

//转换时间为:xx分钟前
+ (NSString *)specifyTime:(NSString *)currentTime;

+ (BOOL)isInSameWeek:(NSString *)time1 with:(NSString *)time2;

+ (NSString *)getCurrentDayWith:(NSDate *)date;
@end

