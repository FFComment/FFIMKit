//
//  LocalTimeUtil.m
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "LocalTimeUtil.h"
#import "sqliteADO.h"
#import "NSDate+Exts.h"
@implementation LocalTimeUtil


+ (BOOL)isTodayWith:(NSString *)dayTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    
    return [strDate isEqualToString:dayTime];
}

+ (NSString *)getCurrentTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}


//系统时间转化为时间戳
+ (NSString *)getTimestamp
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[dateToDay timeIntervalSince1970]];
    return timeSp;
}



+ (NSString *)getLocalTimeWith:(NSString *)serverTime
{
    long long time = [serverTime longLongValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_cn"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return dateString;
}

+ (NSDate *)dateFrom:(NSString *)time
{
    time = [time substringToIndex:19];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_cn"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   return [dateFormatter dateFromString:time];
}


+ (NSString *)getLocalTimeWithNormal:(NSString *)tcpTime
{
    if(tcpTime.length == 0 || tcpTime == nil)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        return [NSString stringWithFormat:@"%@",dateString];
    }
    long long time = [tcpTime longLongValue]/1000;
    long microSecond = [tcpTime longLongValue]%1000;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return [NSString stringWithFormat:@"%@.%ld",dateString,microSecond];
}

+ (NSString *)getFinalTime:(NSString *)time
{
    if(time.length >= 19)
    {
        time = [time substringToIndex:19];
    }
    
    NSDate *inputDate = [self dateFrom:time];
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:inputDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger hourSep = cmp2.hour - cmp1.hour;
    NSInteger minSep = cmp2.minute - cmp1.minute;
   // NSInteger secondSep = cmp2.second - cmp1.second;
    
    NSInteger sep = [inputDate distanceInDaysToDate:[NSDate date]];

    NSDictionary * weekDic = @{
                             @"Monday"      : @"1",
                             @"Tuesday"     : @"2",
                             @"Wednesday"   :@"3",
                             @"Thursday"    :@"4",
                             @"Friday"      :@"5",
                             @"Saturday"    :@"6",
                             @"Sunday"      :@"7"
                            };
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        
        NSString *retStr;
        if (hourSep<1&&minSep<1) {
            retStr = @"刚刚";
        }else if(hourSep<1){
            retStr = [NSString stringWithFormat:@"%ld分钟前",minSep];
        }else {
            retStr = [NSString stringWithFormat:@"%ld小时前",hourSep];
        }
        return retStr;
    }
    else if (sep < 7 )
    {
        [formatter setDateFormat:@"EEEE"];
        NSString *w = [formatter stringFromDate:[NSDate date]];
        int weekday = [weekDic[w] intValue];
        if(sep < weekday)
        {
            NSInteger currentWeekDay = weekday-sep;
            return [NSString stringWithFormat:@"周%ld",currentWeekDay];
        }
        else
        {
            if([cmp1 month] == [cmp2 month])
            {
                return [NSString stringWithFormat:@"%ld天前",sep];
            }
            else
            {
                formatter.dateFormat = @"yyyy-MM-dd HH:mm";
            }
            
        }
    }
    else if([cmp1 month] == [cmp2 month]){
        
         return [NSString stringWithFormat:@"%ld天前",sep];
        
    }
    else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    else {
        formatter.dateFormat = @"yyyy年";
    }
    NSString *finalTime = [formatter stringFromDate:inputDate];
    return finalTime;
}


+ (BOOL)isToday:(NSString *)time
{
    if(time.length < 10)
    {
        return NO;
    }
    
    
    NSString * todatTime = [self getCurrentTime];
    NSString * compareTime = [time substringToIndex:10];
    NSString * currentTime = [todatTime substringToIndex:10];
    return ([compareTime isEqualToString:currentTime]) ? YES : NO;
}

+ (BOOL)isYesterday:(NSString *)time
{
    if(time.length < 10)
    {
        return NO;
    }
    
    NSString * todatTime = [self getCurrentTime];
    NSString * comYM = [time substringToIndex:7];
    NSString *currentYM = [time substringToIndex:7];
    
    if([comYM isEqualToString: currentYM])
    {
        NSString * compareTime = [time substringWithRange:NSMakeRange(8, 2)];
        NSString * currentTime = [todatTime substringWithRange:NSMakeRange(8, 2)];
        if([compareTime intValue]+1 == [currentTime intValue])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isShowTimeLabel:(NSString *)time belongToTime:(NSString **)belong
{
    int   currentMin = [[time substringWithRange:NSMakeRange(14, 2)]intValue];
    int   currentSecond = [[time substringWithRange:NSMakeRange(17, 2)]intValue];
    //计算时间分钟数
    if(currentSecond > 0)
    {
        currentMin++;
    }
    currentMin = ( (currentMin/DURATION_IN_CHATVIEW) + (currentMin%DURATION_IN_CHATVIEW == 0 ? 0 : 1)) * DURATION_IN_CHATVIEW;
    NSString *hourBefore = [time substringToIndex:14];
    NSString * comTime = [NSString stringWithFormat:@"%@%d",hourBefore,currentMin];
    *belong = comTime;
    
   return   [sqliteADO  isHaveExistedShowtimeLabelMsg:comTime];
}

+ (NSString *)getCurrentMonth
{
    NSString *year_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_YEAR];
    NSString *month_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_MONTH];

    if(year_ && month_)
    {
        return [NSString stringWithFormat:@"%@%@",year_,month_];
    }
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMM"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (NSString *)specifyTime:(NSString *)currentTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    //创建了两个日期对象
    NSDate *date1=[dateFormatter dateFromString:currentTime];
    NSDate *date2=[dateFormatter dateFromString:[LocalTimeUtil getCurrentTime]];
    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    
    if(hours == 0 && days == 0)
    {
        return [NSString stringWithFormat:@"1小时内"];
    }
    
    if(days == 0 )
    {
        return [NSString stringWithFormat:@"%d小时前",hours];
    }
    
    return [NSString stringWithFormat:@"%d天前",days];;
}

+ (BOOL)isInSameWeek:(NSString *)time1 with:(NSString *)time2
{
    
    
    return YES;
}

+ (NSString *)getCurrentDayWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
@end
