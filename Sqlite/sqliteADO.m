    //
//  sqliteADO.m
//  JZH_Test
//
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "sqliteADO.h"
#import "SqliteDataManager.h"
#import "LocalTimeUtil.h"
#import "ADTIMContacter.h"
#import "ADTIMGroup.h"
#import "NSString+Pinyin.h"
@implementation sqliteADO

+ (void)initDatabase
{
   [SqliteDataManager sharedInstance];
}


#pragma mark - 聊天

+ (BOOL)insertMessage:(ADTChatMessage *)msg
{
        #if KEY_CHAT_WITH_WS
        NSString *currentTime = [LocalTimeUtil getCurrentTime];
        #else
        NSString *currentTime = msg.m_strTime.length == 0 ?[LocalTimeUtil getLocalTimeWithNormal:nil]: msg.m_strTime;
        #endif
        int   currentMin = [[currentTime substringWithRange:NSMakeRange(14, 2)]intValue];
        int   currentSecond = [[currentTime substringWithRange:NSMakeRange(17, 2)]intValue];
      //计算时间分钟数
        if(currentSecond > 0)
        {
            currentMin++;
        }
        currentMin = ( (currentMin/DURATION_IN_CHATVIEW) + (currentMin%DURATION_IN_CHATVIEW == 0 ? 0 : 1)) * DURATION_IN_CHATVIEW;
        NSString *hourBefore = [currentTime substringToIndex:14];
        NSString * comTime = [NSString stringWithFormat:@"%@%d",hourBefore,currentMin];
        msg.m_strBelongToDuration = comTime;
        BOOL isExisted = [self isHaveExistedShowtimeLabelMsg:comTime];
        msg.m_timeLabState = isExisted ? ENUM_TIMELAB_STATE_HIDDEN : ENUM_TIMELAB_STATE_SHOW;
        //判断此消息在自己所属时间段内(5min ：1-5，6-10...)有无已显示时间提示的纪录
        //有责将此消息的对应字段设为0(不需要再显示了),无则写如1

    return  [[SqliteDataManager sharedInstance]insertMessage:msg];
}



+ (NSArray *)queryAllMessages:(ENUM_MSG_TYPE)queryMsgType
{
    return [[SqliteDataManager sharedInstance]queryAllMessages:queryMsgType];
}



+ (NSArray *)queryCellChatLastMsg:(ENUM_MSG_TYPE)queryMsgType 
{
    return [[SqliteDataManager sharedInstance]queryCellChatLastMsg:queryMsgType];
}


+ (NSArray *)queryAllMessagesWithChatId:(NSString *)chatId
{
    
    return [[SqliteDataManager sharedInstance]queryAllMessagesWithChatId:chatId];
}

+ (ADTChatMessage *)queryFinalMessageWithChatId:(NSString *)chatId
{
    return [[SqliteDataManager sharedInstance]queryFinalMessageWithChatId:chatId withContentType:ENUM_MSG_TYPE_ALL];
}


+ (NSInteger)numOfUnreadedMessage
{
    return [[SqliteDataManager sharedInstance]numOfUnreadedMessage];
}

//获取作业通知个数
+ (NSInteger)numOfUnreadHomeworkNoti
{
    return [[SqliteDataManager sharedInstance]numOfUnreadHomeworkNoti];
}

+ (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withCid:(NSString*)cid
{
    return [[SqliteDataManager sharedInstance]updateMsgStatusTo:currentStatus withCid:cid];
}

+ (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withChatid:(NSString*)chatId
{
    return [[SqliteDataManager sharedInstance]updateMsgStatusTo:currentStatus withChatid:chatId];
}


//修改某个文件消息的url值
+ (BOOL)updateMsgUrlWith:(NSString *)url withCid:(NSString*)cid
{
    return [[SqliteDataManager sharedInstance]updateMsgUrlWith:url withCid:cid];
}

+ (BOOL)deleteAllMessagesWith:(NSString *)oppositeChaterId
{
    return [[SqliteDataManager sharedInstance]deleteAllMsgWithOppositeChatId:oppositeChaterId];
}

+ (BOOL)deleteAnMsgWith:(NSString *)DB_Id
{
    return [[SqliteDataManager sharedInstance]deleteAnMsgWith:DB_Id];
}


+ (long)numOfGroupMember:(NSString *)groupId
{
    return [[SqliteDataManager sharedInstance]numOfGroupMember:groupId];
}

+ (NSString *)nameOfGroup:(NSString *)groupId
{
    return [[SqliteDataManager sharedInstance]nameOfGroup:groupId];
}

+(NSInteger)numOfUnreadedMessageWithMsg:(ADTChatMessage *)msg
{
    return [[SqliteDataManager sharedInstance]numOfUnreadedMessageWithMsg:msg];

}

+ (NSArray *)queryContactsWithUserId:(NSString *)userId
{
    return [[SqliteDataManager sharedInstance]queryContactsWithUserId:userId];
}

+ (ADTIMContacter *)queryChaterWithUserId:(NSString *)userId
{
    return [[SqliteDataManager sharedInstance]queryChaterWithUserId:userId];
}

+ (BOOL)updateTimeTitleState:(ENUM_TIMELAB_STATE)state withCid:(NSString*)cid
{
    return [[SqliteDataManager sharedInstance]updateTimeTitleState:state withCid:cid];
}

+ (ENUM_TIMELAB_STATE)checkTimeTitleStateWtiCid:(NSString*)cid
{
    return [[SqliteDataManager sharedInstance]checkTimeTitleStateWtiCid:cid];
}

//清楚所有作业信息的状态
+ (BOOL)updateAllHomeworkMsgStateTo:(ENUM_MESSAGESTATUS)state;
{
    return [[SqliteDataManager sharedInstance]updateAllHomeworkMsgStateTo:state];
}

//此时间段内是否已有显示时间提示的纪录
+ (BOOL)isHaveExistedShowtimeLabelMsg:(NSString *)time
{
    return [[SqliteDataManager sharedInstance]isHaveExistedShowtimeLabelMsg:time];
}

//获取当前纪录是否需要展示时间提示
+ (ENUM_TIMELAB_STATE)timeLabelStateWith:(NSString*)Cid
{
    return [[SqliteDataManager sharedInstance]timeLabelStateWith:Cid];
}

+ (BOOL)isExistedGroupWith:(NSString *)groupId
{
   return [[SqliteDataManager sharedInstance]isExistedGroupWith:groupId];
}
#pragma mark - 联系人
+ (BOOL)clearContactTable
{
    return [[SqliteDataManager sharedInstance]clearContactTable];
}

+ (BOOL)clearContactTableWithGroupId:(NSString *)groupId
{
    return [[SqliteDataManager sharedInstance]clearContactTableWithGroupId:groupId];
}

+ (BOOL)clearGroupTableWithGroupId:(NSString *)groupId
{
    return [[SqliteDataManager sharedInstance]clearGroupTableWithGroupId:groupId];
}

//保存联系人到数据库
+ (BOOL)saveContactToDB:(NSArray *)arrMember withGroupID:(NSString *)groupID
{
    if(arrMember.count == 0)
    {
        return NO;
    }
    
    [self clearContactTableWithGroupId:groupID];
    
    for(NSDictionary *cell in arrMember)
    {
        ADTIMContacter *member = [[ADTIMContacter alloc]init];
        member.m_strGroupId = [NSString stringWithFormat:@"%@",groupID];
        member.m_strId= [cell stringWithFilted:@"userid"];
        member.m_strName = [cell stringWithFilted:@"name"];
        member.m_strMid = [cell stringWithFilted:@"mid"];
        member.m_strRemoteId = [cell stringWithFilted:@"remoteid"];
        member.m_strType = [cell stringWithFilted:@"type"];
        member.m_strRole = [cell stringWithFilted:@"role"];
        member.m_strDn = [cell stringWithFilted:@"dn"];
        member.m_strShortDn = [[cell stringWithFilted:@"short_dn"] integerValue] == 0 ? @"" : [cell stringWithFilted:@"short_dn"];
        member.m_strLoginType = [cell stringWithFilted:@"login_type"];
        member.m_studentid = [cell stringWithFilted:@"studentid"];
        member.m_studentname = [cell stringWithFilted:@"studentname"];
        member.m_student_relation = [cell stringWithFilted:@"student_relation"];
        member.m_isOpen_phone = [[cell stringWithFilted:@"isopen_phone"]longLongValue];
        member.m_pinyin = [member.m_strName transChineseStringToPingyin];
        [[SqliteDataManager  sharedInstance]saveContactToDB:member];
        [member release];
    }
    return YES;
}

//保存群组
+ (BOOL)saveGroupToDB:(NSDictionary *)dic
{
    ADTIMGroup *g = [[[ADTIMGroup alloc]init]autorelease];
    g.m_strGroupId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"classid"]];
    g.m_strId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    
    // is_shortdn 表示用户是否在该班级下开通班级网，1表示开通，2表示未开通
    g.m_isHasShortDn = [[dic stringForKey:@"is_shortdn"]integerValue] == 1;
    g.m_strGroupName = [dic stringForKey:@"name"];
    g.m_strRole = [dic stringForKey:@"role"];
    g.m_strSchoolName = [dic stringForKey:@"school_name"];
    g.m_strType = [dic stringForKey:@"type"];
    g.m_strNewClassId = [dic stringForKey:@"newclassid"];
    g.m_stuNum = [dic stringForKey:@"studentnum"];
    if([[SqliteDataManager sharedInstance]saveGroupToDB:g])
    {
       return YES;
    }
    return NO;
}

+ (NSArray *)queryAllContactFromDBWith:(NSString *)groupID
{
    return [[SqliteDataManager sharedInstance]queryAllContactFromDBWith:groupID];
}

+ (NSArray *)queryAllGroupFromDB
{
    return [[SqliteDataManager sharedInstance]queryAllGroupFromDB];
}

+ (BOOL) isNeedQueryContactsAndGroupData
{
    return [[SqliteDataManager sharedInstance]isNeedQueryContactsAndGroupData];
}

//找到某个群组信息
+ (ADTIMGroup *)queryGroupWith:(NSString *)groupId
{
    return [[SqliteDataManager sharedInstance]queryGroupWith:groupId];
}
+ (ADTIMGroup *)queryGroupWithId:(NSString *)strId{
    return [[SqliteDataManager sharedInstance]queryGroupWithId:strId];
}

+ (NSArray *)queryContacterWith:(NSString *)charString
{
    return [[SqliteDataManager sharedInstance]queryContacterWith:charString];
}
#pragma mark - 密码用户

+ (BOOL)insertUserTB:(NSString *)usreName withPassword:(NSString *)pwd withUserId:(NSString *)userId withUserType:(NSString *)type
{
    return [[SqliteDataManager sharedInstance]insertUserTB:usreName withPassword:pwd withUserId:userId withUserType:type];
}

+ (BOOL)deleteAllUser
{
    return [[SqliteDataManager sharedInstance]deleteAllUser];
}

+ (BOOL)deleteUserWithName:(NSString *)name
{
    return [[SqliteDataManager sharedInstance]deleteUserWithName:name];
}

+ (NSArray *)queryAllUser
{
    return [[SqliteDataManager sharedInstance]queryAllUser];
}

+ (BOOL)updateUserWithName:(NSString *)newName withUserId:(NSString *)userId
{
    return [[SqliteDataManager sharedInstance]updateUserWithName:newName withUserId:userId];

}

+ (BOOL)updateUserWithPassword:(NSString *)newPwd withName:(NSString *)newName
{
    return [[SqliteDataManager sharedInstance]updateUserWithPassword:newPwd withName:newName];
}

#pragma mark - 特色应用

+ (NSArray *)queryAllAddedApps
{
   return [[SqliteDataManager sharedInstance]queryAllAddedApps];
}

//获取所有特色应用
+ (NSArray *)queryAllApps
{
    return [[SqliteDataManager sharedInstance]queryAllApps];
}

//增加一个应用纪录
+ (BOOL)addAnApp:(NSString *)appId
{
    return [[SqliteDataManager sharedInstance]addAnApp:appId];
}

//删除一个应用纪录
+ (BOOL)deleteAnApp:(NSString *)appId
{
    return [[SqliteDataManager sharedInstance]deleteAnApp:appId];
}

//此应用是否已在数据库中
+ (BOOL)isSaveInDBWith:(NSString *)appId
{
    return [[SqliteDataManager sharedInstance]isSaveInDBWith:appId];
}

+ (BOOL)addDefaultFun
{
    return [[SqliteDataManager sharedInstance]addDefaultFun];
}

#pragma mark - 微课播放历史
+ (BOOL)insertPlayHistory:(NSString *)videoId WithCover:(NSString *)coverUrl WithTitle:(NSString *)videoTitle WithTime:(NSString *)playTime
{
   return  [[SqliteDataManager sharedInstance]insertPlayHistory:videoId WithCover:coverUrl WithTitle:videoTitle WithTime:playTime];
}

+ (BOOL)deleteVideoHistoryWith:(NSString *)videoId
{
    return [[SqliteDataManager sharedInstance]deleteVideoHistoryWith:videoId];
}

+ (NSArray *)queryAllVideoHistory
{
    return [[SqliteDataManager sharedInstance]queryAllVideoHistory];
}

#pragma mark -  未做完作业
+ (BOOL)saveUnCompletedHomework:(NSString *)content WithStudentId:(NSString *)studentId WithQuestionId:(NSString *)questionId
{
    return [[SqliteDataManager sharedInstance]saveUnCompletedHomework:content WithStudentId:studentId WithQuestionId:questionId];
}

+ (NSDictionary *)unCompletedHomeworkWith:(NSString *)questionId  WithStudentId:(NSString *)studentId
{
    return [[SqliteDataManager sharedInstance]unCompletedHomeworkWith:questionId WithStudentId:studentId];
}

+ (BOOL)deleteRecordWith:(NSString *)questionId
{
    return [[SqliteDataManager sharedInstance]deleteRecordWith:questionId];
}

#pragma mark - @答疑
+ (BOOL)insertAskAtInfo:(NSDictionary *)info
{
    int msgType = [info[@"type"]intValue];

    if(msgType == 4)
    {
        ADTChatMessage *msg = [[[ADTChatMessage alloc]init]autorelease];
        msg.m_strTime = [LocalTimeUtil getCurrentTime];
        msg.m_contentType = ENUM_MSG_TYPE_ASK_AT;
        msg.m_msgid = info[@"type_id"]; //@"10011628";//测试数据
        return [[SqliteDataManager sharedInstance]insertMessage:msg];
    }
    return NO;
}

+ (ADTChatMessage *)queryQuestionMsg
{
  return [[SqliteDataManager sharedInstance]queryQuestionMsg];
}

+ (NSArray *)queryAllAnswerAT
{
    return [[SqliteDataManager sharedInstance]queryAllAnswerAT];
}


//用户自动登录信息
+ (BOOL)saveUserAutoLoginInfo:(AutoLoginInfoDTO *)dto {
    return [[SqliteDataManager sharedInstance] saveUserAutoLoginInfo:dto];
}

+ (AutoLoginInfoDTO *)queryUserAutoLoginInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] queryUserAutoLoginInfo:userId];
}

+ (BOOL)modifyUserAutoLoginInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue {
    return [[SqliteDataManager sharedInstance] modifyUserAutoLoginInfo:userId lineNameStr:lineName lineValueStr:lineValue];
}

+ (BOOL)deleteUserAutoLoginInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] deleteUserAutoLoginInfo:userId];
}

//用户登录返回信息
+ (BOOL)saveLoginUserReturnInfo:(LoginReturnInfoDTO *)dto {
    return [[SqliteDataManager sharedInstance] saveLoginUserReturnInfo:dto];
}

+ (LoginReturnInfoDTO *)queryLoginUserReturnInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] queryLoginUserReturnInfo:userId];
}

+ (BOOL)modifyLoginUserReturnInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue {
    return [[SqliteDataManager sharedInstance] modifyLoginUserReturnInfo:userId lineNameStr:lineName lineValueStr:lineValue];
    
}

+ (BOOL)deleteLoginuserreturnInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] deleteLoginuserreturnInfo:userId];
}

//用户小孩信息
+ (BOOL)saveUserChildrenInfo:(LoginUserChildrenInfoDTO *)dto {
    return [[SqliteDataManager sharedInstance] saveUserChildrenInfo:dto];
}

+ (NSArray *)queryUserChildrenInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] queryUserChildrenInfo:userId];
    
}

+ (BOOL)modifyUserChildrenInfo:(NSString *)childId ParentId:(NSString*)parentId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue {
    return [[SqliteDataManager sharedInstance] modifyUserChildrenInfo:childId ParentId:parentId lineNameStr:lineName lineValueStr:lineValue];
    
}

+ (BOOL)deleteUserChildrenInfo:(NSString *)userId {
    return [[SqliteDataManager sharedInstance] deleteUserChildrenInfo:userId];
    
}


//保存发送人信息
+ (BOOL)saveHomeAndSchoolSendInfo:(HomeAndSchoolSendInfoDTO *)dto {
    return [[SqliteDataManager sharedInstance] saveHomeAndSchoolSendInfo:dto];
}

+ (HomeAndSchoolSendInfoDTO *)queryHomeAndSchoolSendInfo:(NSString *)sendType {
    return [[SqliteDataManager sharedInstance] queryHomeAndSchoolSendInfo:sendType];
    
}

+ (BOOL)deleteHomeAndSchoolSendInfoTable:(NSString *)sendType {
    return [[SqliteDataManager sharedInstance] deleteHomeAndSchoolSendInfoTable:sendType];
    
}


#pragma mark - 最近联系人

+ (BOOL)insertHistoryContactWith:(ADTIMContacter *)contact
{
    [[SqliteDataManager sharedInstance]deleteHistoryContactWith:contact];
    return  [[SqliteDataManager sharedInstance]insertHistoryContactWith:contact];
}

+ (BOOL)deleteHistoryContactWith:(ADTIMContacter *)contact
{
     return  [[SqliteDataManager sharedInstance]deleteHistoryContactWith:contact];
}

+ (NSArray *)queryAllHistoryContacts
{
     return  [[SqliteDataManager sharedInstance]queryAllHistoryContacts];
}


@end
