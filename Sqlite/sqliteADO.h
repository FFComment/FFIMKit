//
//  sqliteADO.h
//  JZH_Test
//  业务逻辑封装类
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTChatMessage.h"
#import"ADTIMGroup.h"
#import "ADTIMContacter.h"
#import "LoginInfoDTO.h"
#import "HomeAndSchoolSendInfoDTO.h"

@interface sqliteADO : NSObject

+ (void)initDatabase;

#pragma mark - 聊天

//插入消息
+ (BOOL)insertMessage:(ADTChatMessage *)msg;

/*根据消息的类型查询聊天纪录
 */
+ (NSArray *)queryAllMessages:(ENUM_MSG_TYPE)queryMsgType;

//根据类型获取所有聊天的组(单聊,群组,作业或者全部)
+ (NSArray *)queryCellChatLastMsg:(ENUM_MSG_TYPE)queryMsgType ;

//根据chatId获取当前id下所有的聊天信息
+ (NSArray *)queryAllMessagesWithChatId:(NSString *)chatId;

//根据chatId获取当前id下最后一个的聊天信息
+ (ADTChatMessage *)queryFinalMessageWithChatId:(NSString *)chatId;

//获取所有未读消息的个数
+(NSInteger)numOfUnreadedMessage;

//获取所有未读消息的个数
+(NSInteger)numOfUnreadedMessageWithMsg:(ADTChatMessage *)msg;

//获取作业通知个数
+ (NSInteger)numOfUnreadHomeworkNoti;

/*更新某天消息为已读
 */
+ (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withCid:(NSString*)cid;

+ (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withChatid:(NSString*)chatId;

//修改某个文件消息的url值
+ (BOOL)updateMsgUrlWith:(NSString *)url withCid:(NSString*)cid;

//删除与某个聊天者的所有聊天纪录
+ (BOOL)deleteAllMessagesWith:(NSString *)oppositeChaterId;

+ (BOOL)deleteAnMsgWith:(NSString *)DB_Id;

+ (long)numOfGroupMember:(NSString *)groupId;

+ (NSString *)nameOfGroup:(NSString *)groupId;

+ (BOOL)updateTimeTitleState:(ENUM_TIMELAB_STATE)state withCid:(NSString*)cid;

+ (ENUM_TIMELAB_STATE)checkTimeTitleStateWtiCid:(NSString*)cid;

//清楚所有作业信息的状态
+ (BOOL)updateAllHomeworkMsgStateTo:(ENUM_MESSAGESTATUS)state;

//此时间段内是否已有显示时间提示的纪录
+ (BOOL)isHaveExistedShowtimeLabelMsg:(NSString *)time;

//获取当前纪录是否需要展示时间提示
+ (ENUM_TIMELAB_STATE)timeLabelStateWith:(NSString*)Cid;

+ (NSArray *)queryContacterWith:(NSString *)charString;
#pragma mark - 联系人 

+ (BOOL)clearContactTable;

//清除一般联系人表数据
+ (BOOL)clearContactTableWithGroupId:(NSString *)groupId;

//清除群组表数据
+ (BOOL)clearGroupTableWithGroupId:(NSString *)groupId;

//保存联系人到数据库
+ (BOOL)saveContactToDB:(NSArray *)arrMember withGroupID:(NSString *)groupID;

//保存群组
+ (BOOL)saveGroupToDB:(NSDictionary *)dic;


//根据群组id检索此群组下的所有联系人数组
+ (NSArray *)queryAllContactFromDBWith:(NSString *)groupID;

//检索所有群组数据
+ (NSArray *)queryAllGroupFromDB;

//一般数据请求后就会放在数据库中,在每次程序启动后会检查是否需要请求数据
+ (BOOL)isNeedQueryContactsAndGroupData;

//找到某个群组信息
+ (ADTIMGroup *)queryGroupWith:(NSString *)groupId;
+ (ADTIMGroup *)queryGroupWithId:(NSString *)strId;

+ (NSArray *)queryContactsWithUserId:(NSString *)userId;

+ (ADTIMContacter *)queryChaterWithUserId:(NSString *)userId;

+ (BOOL)isExistedGroupWith:(NSString *)groupId;

#pragma mark - 密码用户

//插入用户名和密码至用户表
+ (BOOL)insertUserTB:(NSString *)usreName withPassword:(NSString *)pwd withUserId:(NSString *)userId withUserType:(NSString *)type;

//根据用户名删除纪录
+ (BOOL)deleteUserWithName:(NSString *)name;

//删除所有用户数据
+ (BOOL)deleteAllUser;

//检索所有用户数据
+ (NSArray *)queryAllUser;

//更新用户信息
+ (BOOL)updateUserWithName:(NSString *)newName  withUserId:(NSString *)userId;

+ (BOOL)updateUserWithPassword:(NSString *)newPwd withName:(NSString *)newName;

#pragma mark - 特色应用

+ (NSArray *)queryAllAddedApps;
//获取所有特色应用
+ (NSArray *)queryAllApps;

//增加一个应用纪录
+ (BOOL)addAnApp:(NSString *)appId;

//删除一个应用纪录
+ (BOOL)deleteAnApp:(NSString *)appId;

//此应用是否已在数据库中
+ (BOOL)isSaveInDBWith:(NSString *)appId;

+ (BOOL)addDefaultFun;

#pragma mark - 微课播放历史

+ (BOOL)insertPlayHistory:(NSString *)videoId WithCover:(NSString *)coverUrl WithTitle:(NSString *)videoTitle WithTime:(NSString *)playTime;

+ (BOOL)deleteVideoHistoryWith:(NSString *)videoId;

+ (NSArray *)queryAllVideoHistory;

#pragma mark -  未做完作业
+ (BOOL)saveUnCompletedHomework:(NSString *)content WithStudentId:(NSString *)studentId WithQuestionId:(NSString *)questionId;

+ (NSDictionary *)unCompletedHomeworkWith:(NSString *)questionId WithStudentId:(NSString *)studentId;

+ (BOOL)deleteRecordWith:(NSString *)questionId;

#pragma mark - @答疑
+ (BOOL)insertAskAtInfo:(NSDictionary *)info;

+ (ADTChatMessage *)queryQuestionMsg;

+ (NSArray *)queryAllAnswerAT;

//用户自动登录信息
+ (BOOL)saveUserAutoLoginInfo:(AutoLoginInfoDTO *)dto;
+ (AutoLoginInfoDTO *)queryUserAutoLoginInfo:(NSString *)userId;
+ (BOOL)modifyUserAutoLoginInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
+ (BOOL)deleteUserAutoLoginInfo:(NSString *)userId;

//用户登录返回信息
+ (BOOL)saveLoginUserReturnInfo:(LoginReturnInfoDTO *)dto;
+ (LoginReturnInfoDTO *)queryLoginUserReturnInfo:(NSString *)userId;
+ (BOOL)modifyLoginUserReturnInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
+ (BOOL)deleteLoginuserreturnInfo:(NSString *)userId;

//用户小孩信息
+ (BOOL)saveUserChildrenInfo:(LoginUserChildrenInfoDTO *)dto;
+ (NSArray *)queryUserChildrenInfo:(NSString *)userId;
+ (BOOL)modifyUserChildrenInfo:(NSString *)childId ParentId:(NSString*)parentId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue;
+ (BOOL)deleteUserChildrenInfo:(NSString *)userId;


//保存发送人信息
+ (BOOL)saveHomeAndSchoolSendInfo:(HomeAndSchoolSendInfoDTO *)dto;
+ (HomeAndSchoolSendInfoDTO *)queryHomeAndSchoolSendInfo:(NSString *)sendType;
+ (BOOL)deleteHomeAndSchoolSendInfoTable:(NSString *)sendType;

#pragma mark - 最近联系人 

+ (BOOL)insertHistoryContactWith:(ADTIMContacter *)contact;
+ (BOOL)deleteHistoryContactWith:(ADTIMContacter *)contact;
+ (NSArray *)queryAllHistoryContacts;
@end
