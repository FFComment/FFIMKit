//
//  SqliteDataManager.h
//  JZH_Test
//  数据库管理类
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ADTChatMessage.h"
#import "ADTIMGroup.h"
#import "ADTIMContacter.h"
#import "HomeAndSchoolSendInfoDTO.h"
#import "NewMsgModel.h"

@interface SqliteDataManager : NSObject
{
    sqlite3   *m_db;
}

SINGLETON_FOR_HEADER(SqliteDataManager)

- (BOOL)createTable:(NSString *)tableName;

#pragma mark - 聊天

- (BOOL)insertMessage:(ADTChatMessage *)msg;

- (NSArray *)queryAllMessages:(ENUM_MSG_TYPE)queryMsgType;

//根据类型获取所有聊天的组(单聊,群组,作业或者全部)
- (NSArray *)queryCellChatLastMsg:(ENUM_MSG_TYPE)queryMsgType;

//根据chatId获取当前id下所有的聊天信息
- (NSArray *)queryAllMessagesWithChatId:(NSString *)chatId;

- (ADTChatMessage *)queryFinalMessageWithChatId:(NSString *)chatId withContentType:(ENUM_MSG_TYPE)msgType;

- (NSInteger)numOfUnreadedMessage;

- (NSInteger)numOfUnreadHomeworkNoti;

//根据chatid获取此会话下的所有未读消息的个数
- (NSInteger)numOfUnreadedMessageWithMsg:(ADTChatMessage *)msg;

- (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withCid:(NSString*)cid;

- (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withChatid:(NSString*)chatId;

//修改某个文件消息的url值
- (BOOL)updateMsgUrlWith:(NSString *)url withCid:(NSString*)cid;

- (BOOL)deleteAllMsgWithOppositeChatId:(NSString *)oppositeChatId;

- (BOOL)deleteAnMsgWith:(NSString *)DB_Id;

- (BOOL)updateTimeTitleState:(ENUM_TIMELAB_STATE)state withCid:(NSString*)cid;

- (ENUM_TIMELAB_STATE)checkTimeTitleStateWtiCid:(NSString*)cid;

//清楚所有作业信息的状态
- (BOOL)updateAllHomeworkMsgStateTo:(ENUM_MESSAGESTATUS)state;

//此时间段内是否已有显示时间提示的纪录
- (BOOL)isHaveExistedShowtimeLabelMsg:(NSString *)time;

//获取当前纪录是否需要展示时间提示
- (ENUM_TIMELAB_STATE)timeLabelStateWith:(NSString*)Cid;


#pragma mark - 联系人或群组成员保存以及查询

- (BOOL)clearContactTable;

- (BOOL)clearContactTableWithGroupId:(NSString *)groupId;

- (BOOL)clearGroupTableWithGroupId:(NSString *)groupId;

//保存联系人到数据库
- (BOOL)saveContactToDB:(ADTIMContacter *)member;

//保存群组
- (BOOL)saveGroupToDB:(ADTIMGroup *)group;

- (NSArray *)queryAllContact:(NSString *)key;

- (NSArray *)queryAllContact;

// 获取可邀请的用户列表
- (NSArray *)queryAllContactCanBeInvited;

// 更新用户的被邀请状态
- (BOOL)updataContactLoginType:(NSString *)strType withID:(NSString *)strId;

//找到某个群组信息
- (ADTIMGroup *)queryGroupWith:(NSString *)groupId;
- (ADTIMGroup *)queryGroupWithId:(NSString *)strId;

- (NSArray *)queryAllContactFromDBWith:(NSString *)groupID;

- (NSArray *)queryAllGroupFromDB;

- (BOOL) isNeedQueryContactsAndGroupData;

- (long)numOfGroupMember:(NSString *)groupId;

- (NSString *)nameOfGroup:(NSString *)groupId;

- (ADTIMContacter *)queryChaterWithUserId:(NSString *)userId;

- (NSArray *)queryContactsWithUserId:(NSString *)userId;

//判断这个群组是否存在
- (BOOL)isExistedGroupWith:(NSString *)groupId;

- (NSArray *)queryContacterWith:(NSString *)charString;


#pragma mark - 聊天置顶

- (BOOL)isNeedTopWithGroupId:(NSString *)groupId;

- (BOOL)updateGroupToNeedTop:(NSString *)groupId;

- (BOOL)updateGroupToNormal:(NSString *)groupId;

- (long)topLevel:(NSString *)groupId;

- (NSInteger)maxTopLevel;

#pragma mark - 群消息设置

- (BOOL)deleteGroupMsgTip:(NSString *)groupId;

- (BOOL)updateGroupMsgTip:(Enum_GroupMsgTipLevel)level withGroupId:(NSString *)groupId;

- (Enum_GroupMsgTipLevel)tipLevel:(NSString *)groupId;

#pragma mark -  查询某个用户d的属性


#pragma mark - 用户密码
- (BOOL)insertUserTB:(NSString *)usreName withPassword:(NSString *)pwd withUserId:(NSString *)userId withUserType:(NSString *)type;

- (BOOL)deleteUserWithName:(NSString *)name;

- (BOOL)deleteAllUser;

- (NSArray *)queryAllUser;

- (BOOL)updateUserWithName:(NSString *)newName withUserId:(NSString *)userId;

- (BOOL)updateUserWithPassword:(NSString *)newPwd withName:(NSString *)newName;

#pragma mark - 特色应用

- (NSArray *)queryAllAddedApps;

//获取所有特色应用
- (NSArray *)queryAllApps;

//增加一个应用纪录
- (BOOL)addAnApp:(NSString *)appId;

//删除一个应用纪录
- (BOOL)deleteAnApp:(NSString *)appId;

//此应用是否已在数据库中
- (BOOL)isSaveInDBWith:(NSString *)appId;

//增加一个应用纪录
- (BOOL)insertApp:(NSString *)appId name : (NSString *)name isAdd:(BOOL)flag;

- (BOOL)addDefaultFun;

#pragma mark - 我的应用改版

- (NSArray *)allInsertedApp;

- (void)insertApp:(NSDictionary *)appInfo;

- (void)deleteApp:(NSString *)appId;

- (BOOL)isInserted:(NSString *)appId;

- (BOOL)updateAppLink:(NSDictionary *)info;

#pragma mark - 微课播放历史

- (BOOL)insertPlayHistory:(NSString *)videoId WithCover:(NSString *)coverUrl WithTitle:(NSString *)videoTitle WithTime:(NSString *)playTime;

- (BOOL)deleteVideoHistoryWith:(NSString *)videoId;

- (NSArray *)queryAllVideoHistory;

#pragma mark -  未做完作业
- (BOOL)saveUnCompletedHomework:(NSString *)content WithStudentId:(NSString *)studentId WithQuestionId:(NSString *)questionId;

- (NSDictionary *)unCompletedHomeworkWith:(NSString *)questionId WithStudentId:(NSString *)studentId;

- (BOOL)deleteRecordWith:(NSString *)questionId;


#pragma mark - @答疑
- (ADTChatMessage *)queryQuestionMsg;

- (NSArray *)queryAllAnswerAT;

#pragma mark - 家校圈的通知草稿

- (BOOL)saveUnsendNotice:(NSDictionary *)noticeInfo;

- (BOOL)deleteNotice;

- (NSDictionary *)queryUnSendNoticeInfo;

#pragma mark - 家校圈的作业草稿

- (BOOL)saveUnsendHomework:(NSDictionary *)noticeInfo;
- (BOOL)deleteHomework;
- (NSDictionary *)queryUnSendHomeworkInfo;

//用户自动登录信息
- (BOOL)saveUserAutoLoginInfo:(AutoLoginInfoDTO *)dto;
- (AutoLoginInfoDTO *)queryUserAutoLoginInfo:(NSString *)userId;
- (BOOL)modifyUserAutoLoginInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
- (BOOL)deleteUserAutoLoginInfo:(NSString *)userId;
//用户登录返回信息
- (BOOL)saveLoginUserReturnInfo:(LoginReturnInfoDTO *)dto;
- (LoginReturnInfoDTO *)queryLoginUserReturnInfo:(NSString *)userId;
- (BOOL)modifyLoginUserReturnInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
- (BOOL)deleteLoginuserreturnInfo:(NSString *)userId;
//用户小孩信息
- (BOOL)saveUserChildrenInfo:(LoginUserChildrenInfoDTO *)dto;
- (NSArray *)queryUserChildrenInfo:(NSString *)userId;
- (BOOL)modifyUserChildrenInfo:(NSString *)childId ParentId:(NSString*)parentId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
- (BOOL)deleteUserChildrenInfo:(NSString *)userId;


//保存发送人信息
- (BOOL)saveHomeAndSchoolSendInfo:(HomeAndSchoolSendInfoDTO *)dto;
- (HomeAndSchoolSendInfoDTO *)queryHomeAndSchoolSendInfo:(NSString *)sendType;
- (BOOL)deleteHomeAndSchoolSendInfoTable:(NSString *)sendType;


#pragma mark - 最近联系人

- (BOOL)insertHistoryContactWith:(ADTIMContacter *)contact;

- (BOOL)deleteHistoryContactWith:(ADTIMContacter *)contact;

- (NSArray *)queryAllHistoryContacts;

#pragma mark - 用户行为统计
-(BOOL)clearUserOperations;
-(BOOL)updateUserOperation:(NSString*)Key;
-(NSArray*)selectAllOperation;

#pragma mark - 处理新消息提醒
-(BOOL)updateNewMsg:(NewMsgModel*)newMsg;
-(NewMsgModel*)getNewMsg:(NSString*)strType ClassId:(NSString*)strClassId;
-(NSArray*)getNewMsgAll;
@end
