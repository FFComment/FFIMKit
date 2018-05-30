//
//  SqliteDataManager.m
//  JZH_Test
//
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#define DBNAME                          @"XXT_XJ_db.db"
#define MESSAGE_TABLE                   @"messageTable"
#define CONTACT_GROUP_TABLE             @"contactGroupTable"
#define  CONTACT_GROUP_MEMBER_TABLE     @"contactGroupMemeberTable"
#define EDUCATION_PROTALS_FIELD_TABLE   @"educationProtalsTable"

#import "SqliteDataManager.h"
#import "LoginUserUtil.h"
#import "ADTChatMessage.h"
@implementation SqliteDataManager

- (void)dealloc
{
    [super dealloc];
}


- (id)init

{
    if(self = [super init])
    {
        [SpeSqliteUpdateManager createOrUpdateDB];
         m_db = [SpeSqliteUpdateManager db];
    }
    return self;
}

SINGLETON_FOR_CLASS(SqliteDataManager)

-(BOOL)execSql:(NSString *)sql
{
    @synchronized(self)
    {
        char *err = NULL;
        if (sqlite3_exec(m_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
        {
            SpeLog(@"数据库操作:%@失败!====%s",sql,err);
            return NO;
        }
        else
        {
            SpeLog(@"操作数据成功==sql:%@",sql);
        }
    }
    return YES;
}

#pragma mark -  数据库操作
- (BOOL)createTable:(NSString *)sql
{
   return [self execSql:sql];
}

#pragma mark - 聊天
- (BOOL)insertMessage:(ADTChatMessage *)msg
{
    @synchronized(self)
    {
    NSString *msgbody = msg.m_strMessageBody;
    msgbody = [msgbody stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'messageTable' ('ID','m_chatId', 'm_strOppositeSideName', 'm_strMessageBody','m_isFromSelf','m_messageStatus','m_strTime','m_oppositeChaterId','m_contentType','m_chatType','mediaPath','loginUserId','duration','timeTitleState','belongToDuration','msgId','fileId','isNeedTop') VALUES ('%@','%@', '%@', '%@','%ld', '%ld', '%@','%@', '%ld', '%ld','%@','%@','%ld','%ld','%@','%@','%@','%@')",msg.m_idInDB, msg.m_chatId,msg.m_strOppositeSideName,msgbody,(long)msg.m_isFromSelf,(long)msg.m_messageStatus,msg.m_strTime,msg.m_oppositeChaterId,(long)msg.m_contentType,(long)msg.m_chatType,msg.m_strMediaPath,[LoginUserUtil userId],(long)msg.m_duration,(long)msg.m_timeLabState,msg.m_strBelongToDuration,msg.m_msgid,msg.m_strFileId,msg.m_strIsNeedTop];
    return [self execSql:sql];
    }
}

- (NSArray *)queryAllMessages:(ENUM_MSG_TYPE)queryMsgType
{
    @synchronized(self)
    {
    if(queryMsgType == 0 )
    {
        queryMsgType = ENUM_MSG_TYPE_ALL;
    }
    NSString *sqlQuery = nil;
    if(queryMsgType == ENUM_MSG_TYPE_ALL)
    {
        //所有消息
        sqlQuery = [NSString stringWithFormat:@"SELECT * FROM messageTable where loginUserId = %@",[LoginUserUtil userId]];
    }
    else if (queryMsgType == ENUM_MSG_TYPE_HOMEWORK)
    {
        //作业通知
        sqlQuery = [NSString stringWithFormat:@"SELECT * FROM messageTable where m_contentType = %d and loginUserId =%@ ",(int)queryMsgType, [LoginUserUtil userId]];
    }
    else if (queryMsgType == ENUM_MSG_TYPE_EXCEPTHOMEWIRK)
    {
        //除了不是作业的都得当消息检索出来
        sqlQuery = [NSString stringWithFormat:@"SELECT * FROM messageTable where m_contentType int(1,2,3,6) and loginUserId = %@", [LoginUserUtil userId]] ;
    }
    else
    {
        SpeLog(@"不知道此时是何种消息类型");
        return nil;
    }
    sqlite3_stmt * statement;
    NSMutableArray *arr =[[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTChatMessage *msg = [[ADTChatMessage alloc]init];
            
            long long autoId = (long long)sqlite3_column_int64(statement, 0);
            
            msg.m_idInDB = [NSString stringWithFormat:@"%lld",autoId];
            
            NSString* chatId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            msg.m_chatId = chatId;
            
            NSString *m_strOppositeSideName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            msg.m_strOppositeSideName = m_strOppositeSideName;
            
            NSString *m_strMessageBody = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            msg.m_strMessageBody = m_strMessageBody;
            
            ENUM_MESSAGEFROM from = (ENUM_MESSAGEFROM)sqlite3_column_int(statement, 4);
            msg.m_isFromSelf = from;
            
            ENUM_MESSAGESTATUS status = (ENUM_MESSAGESTATUS)sqlite3_column_int(statement, 5);
            msg.m_messageStatus = status;
            
            NSString *time = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            msg.m_strTime = time;
            
            NSString* chaterId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            msg.m_oppositeChaterId = chaterId;
            
            ENUM_MSG_TYPE contentType = (ENUM_MSG_TYPE)sqlite3_column_int(statement, 8);
            msg.m_contentType = contentType;
            
            ENUM_CHAT_TYPE chatType = (ENUM_CHAT_TYPE)sqlite3_column_int(statement, 9);
            msg.m_chatType = chatType;
            
            NSString *path = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            msg.m_strMediaPath = path;
            
            msg.m_duration = sqlite3_column_int(statement, 12);
            msg.m_timeLabState = sqlite3_column_int(statement, 13);
            
            msg.m_strBelongToDuration = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
             msg.m_msgid = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            msg.m_strFileId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];

            
            [arr addObject:msg];
            [msg release];
            
        }

        return [arr autorelease];

    }
    [arr release];
    }
    
    return nil;
}

//根据类型获取所有聊天的组(单聊,群组,作业或者全部)
- (NSArray *)queryCellChatLastMsg:(ENUM_MSG_TYPE)queryMsgType
{
    @synchronized(self)
    {
    NSString *sqlQuery= [NSString stringWithFormat:@"SELECT DISTINCT  m_chatId   FROM messageTable where m_contentType in(1,2,3,6) and loginUserId = %@",[LoginUserUtil userId]];
 
    sqlite3_stmt * statement;
    NSMutableArray *arr =[[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //long long  chatId = sqlite3_column_int64(statement, 0);
            NSString *chatId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];

            ADTChatMessage *tempMsg = [self queryFinalMessageWithChatId:chatId withContentType:queryMsgType];
    
            if(tempMsg == nil)
            {
                 continue;
            }

            [arr addObject:tempMsg];
        }
        
        return arr;
        
    }
    }
    return nil;
}

//根据chatId和类型获取当前id下最后一个的聊天信息
- (ADTChatMessage *)queryFinalMessageWithChatId:(NSString *)chatId withContentType:(ENUM_MSG_TYPE)msgType
{
    @synchronized(self)
    {
        
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT  * from messageTable where  loginUserId = '%@'  and m_contentType in(1,2,3,6) and m_chatId = '%@' order by ID DESC limit 0,1 ",[LoginUserUtil userId], chatId];
        
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTChatMessage *msg = [[ADTChatMessage alloc]init];
            
            long long autoId = (long long)sqlite3_column_int64(statement, 0);
            msg.m_idInDB = [NSString stringWithFormat:@"%lld",autoId];
            
            NSString* chatId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            msg.m_chatId = chatId;
            
            NSString *m_strOppositeSideName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            msg.m_strOppositeSideName = m_strOppositeSideName;
            
            NSString *m_strMessageBody = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            msg.m_strMessageBody = m_strMessageBody;
            
            ENUM_MESSAGEFROM from = (ENUM_MESSAGEFROM)sqlite3_column_int(statement, 4);
            msg.m_isFromSelf = from;
            
            ENUM_MESSAGESTATUS status = (ENUM_MESSAGESTATUS)sqlite3_column_int(statement, 5);
            msg.m_messageStatus = status;
            
            NSString *time = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            msg.m_strTime = time;
            
            //long long chaterId = sqlite3_column_int64(statement, 7);
            NSString* chaterId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            msg.m_oppositeChaterId = chaterId;
            
            ENUM_MSG_TYPE contentType = (ENUM_MSG_TYPE)sqlite3_column_int(statement, 8);
            msg.m_contentType = contentType;
            
            ENUM_CHAT_TYPE chatType = (ENUM_CHAT_TYPE)sqlite3_column_int(statement, 9);
            msg.m_chatType = chatType;
            
            NSString *path = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            msg.m_strMediaPath = path;
            
            msg.m_duration = sqlite3_column_int(statement, 12);
            
            msg.m_timeLabState = sqlite3_column_int(statement, 13);
            
            msg.m_strBelongToDuration = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
            msg.m_msgid = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            msg.m_strFileId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];

            return [msg autorelease];
        }
        
    }
    }
    return nil;
}


//根据chatId获取当前id下所有的聊天信息
- (NSArray *)queryAllMessagesWithChatId:(NSString *)chatId
{
    @synchronized(self)
    {
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT * FROM messageTable  where m_chatId = '%@' and loginUserId = '%@' and m_contentType in(1,2,3,6) order by m_strTime",chatId, [LoginUserUtil userId]];
    
    sqlite3_stmt * statement;
    NSMutableArray *arr =[[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTChatMessage *msg = [[ADTChatMessage alloc]init];
            long long autoId = (long long)sqlite3_column_int64(statement, 0);
            msg.m_idInDB = [NSString stringWithFormat:@"%lld",autoId];
            
            NSString* chatId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            msg.m_chatId = chatId;
            
            NSString *m_strOppositeSideName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            msg.m_strOppositeSideName = m_strOppositeSideName;
            
            NSString *m_strMessageBody = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            msg.m_strMessageBody = m_strMessageBody;
            
            ENUM_MESSAGEFROM from = (ENUM_MESSAGEFROM)sqlite3_column_int(statement, 4);
            msg.m_isFromSelf = from;
            
            ENUM_MESSAGESTATUS status = (ENUM_MESSAGESTATUS)sqlite3_column_int(statement, 5);
            msg.m_messageStatus = status;
            
            NSString *time = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            msg.m_strTime = time;
            //long long chaterId = sqlite3_column_int64(statement, 7);
            NSString* chaterId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            msg.m_oppositeChaterId = chaterId;
            
            ENUM_MSG_TYPE contentType = (ENUM_MSG_TYPE)sqlite3_column_int(statement, 8);
            msg.m_contentType = contentType;
            
            ENUM_CHAT_TYPE chatType = (ENUM_CHAT_TYPE)sqlite3_column_int(statement, 9);
            msg.m_chatType = chatType;
            
            NSString *path = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            msg.m_strMediaPath = path;
            
            msg.m_duration = sqlite3_column_int(statement, 12);
            
            msg.m_timeLabState = sqlite3_column_int(statement, 13);
            
            msg.m_strBelongToDuration = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
            msg.m_msgid = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            msg.m_strFileId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];
            msg.m_isInsertLastSection = NO;
            [arr addObject:msg];
            [msg release];
            
            
        }
        
        return arr;
        
    }
    }
    
    
    return nil;
}

- (NSInteger)numOfUnreadedMessage
{
    @synchronized(self)
    {
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT COUNT(*) FROM messageTable where loginUserId = '%@' and m_messageStatus = %ld", [LoginUserUtil userId],(long)ENUM_MESSAGESTATUS_UNREAD];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            return  sqlite3_column_int(statement, 0);
        }
    }
    return 0;
    }
}

- (NSInteger)numOfUnreadHomeworkNoti
{
    @synchronized(self)
    {
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT COUNT(*) FROM messageTable where loginUserId = %@ and m_contentType = %ld and m_messageStatus = %ld", [LoginUserUtil userId],(long)ENUM_MSG_TYPE_HOMEWORK,(long)ENUM_MESSAGESTATUS_UNREAD];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            return  sqlite3_column_int(statement, 0);
        }
    }
    
    return 0;
    }
}



- (NSInteger)numOfUnreadedMessageWithMsg:(ADTChatMessage *)msg
{
    @synchronized(self)
    {
        
    if(msg == nil)
    {
        return 0;
    }
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT COUNT(ID) FROM messageTable where loginUserId = '%@' and m_messageStatus = %ld and m_chatId = '%@'",[LoginUserUtil userId],(long)ENUM_MESSAGESTATUS_UNREAD,msg.m_chatId];

    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            return  sqlite3_column_int(statement, 0);
        }
    }
    
    return 0;
    }
    
}

- (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withCid:(NSString*)cid
{
    return [self execSql: [NSString stringWithFormat:@"update messageTable set m_messageStatus = %d where ID = '%@'",(int)currentStatus,cid]];
}

- (BOOL)updateMsgStatusTo:(ENUM_MESSAGESTATUS)currentStatus withChatid:(NSString*)chatId
{
    return [self execSql: [NSString stringWithFormat:@"update messageTable set m_messageStatus = %d where m_chatId = '%@' and m_messageStatus = %d",(int)currentStatus,chatId, ENUM_MESSAGESTATUS_UNREAD]];
}

//修改某个文件消息的url值
- (BOOL)updateMsgUrlWith:(NSString *)url withCid:(NSString*)cid
{
    return [self execSql: [NSString stringWithFormat:@"update messageTable set mediaPath = '%@' where ID = '%@'",url,cid]];
}

- (BOOL)deleteAllMsgWithOppositeChatId:(NSString *)oppositeChatId
{
    return [self execSql: [NSString stringWithFormat:@"delete from messageTable where m_chatId = '%@' and loginUserId = '%@'",oppositeChatId, [LoginUserUtil userId]]];
}

- (BOOL)deleteAnMsgWith:(NSString *)DB_Id
{
    return [self execSql: [NSString stringWithFormat:@"delete from messageTable where ID = '%@' and loginUserId = %@", DB_Id, [LoginUserUtil userId]]];
}

- (BOOL)updateTimeTitleState:(ENUM_TIMELAB_STATE)state withCid:(NSString*)cid
{
    return [self execSql: [NSString stringWithFormat:@"update messageTable set timeTitleState = %d where ID = '%@'",(int)state,cid]];
}

- (ENUM_TIMELAB_STATE)checkTimeTitleStateWtiCid:(NSString*)cid
{
    NSString * sqlQuery = [NSString stringWithFormat:@"SELECT timeTitleState  FROM messageTable where ID = '%@'",cid];
    ENUM_TIMELAB_STATE   state = ENUM_TIMELAB_STATE_HIDDEN;
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            state = (ENUM_TIMELAB_STATE)sqlite3_column_int(statement, 0);
        }
        
    }
    
    return state;
}

//更新所有作业信息的状态
- (BOOL)updateAllHomeworkMsgStateTo:(ENUM_MESSAGESTATUS)state
{
    return [self execSql: [NSString stringWithFormat:@"update messageTable set m_messageStatus = %d where loginUserId = %@ and m_contentType = %ld",(int)state,[LoginUserUtil userId],(long)ENUM_MSG_TYPE_HOMEWORK]];
}

//此时间段内是否已有显示时间提示的纪录
- (BOOL)isHaveExistedShowtimeLabelMsg:(NSString *)time
{
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT timeTitleState FROM messageTable where loginUserId = %@ and belongToDuration = '%@' and timeTitleState = %d",[LoginUserUtil userId],time,(int)ENUM_TIMELAB_STATE_SHOW];
    sqlite3_stmt * statement;
    int num = 0;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            num =  sqlite3_column_int(statement, 0);
        }
    }
    return num == 0 ? NO : YES;
}


//获取当前纪录是否需要展示时间提示
- (ENUM_TIMELAB_STATE)timeLabelStateWith:(NSString*)Cid
{
    @synchronized(self)
    {
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT timeTitleState FROM messageTable where ID = '%@'",Cid];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            return  (ENUM_TIMELAB_STATE)sqlite3_column_int(statement, 0);
        }
    }
    
    return ENUM_TIMELAB_STATE_SHOW;
    }
}


#pragma mark - 聊天置顶

- (BOOL)isNeedTopWithGroupId:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"select  msgSet from contactGroupTable where groupId = '%@' and loginUserId = '%@'",groupId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *level = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            if(level.length == 0)
            {
                return NO;
            }
            
            if([level integerValue] > 0)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    return NO;
    }
}

- (BOOL)updateGroupToNeedTop:(NSString *)groupId
{
    long insertLevel = [self maxTopLevel]+1;
    
    return [self execSql: [NSString stringWithFormat:@"update contactGroupTable set msgSet = '%ld' where groupId = '%@' and loginUserId = '%@'",insertLevel,groupId,[LoginUserUtil userId]]];
}

- (BOOL)updateGroupToNormal:(NSString *)groupId
{
     return [self execSql: [NSString stringWithFormat:@"update contactGroupTable set msgSet = '%d' where groupId = '%@' and loginUserId = '%@'",0,groupId,[LoginUserUtil userId]]];
}

- (long)topLevel:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"select  msgSet from contactGroupTable where groupId = '%@' and loginUserId = '%@'",groupId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    long    level =0 ;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            level = sqlite3_column_int(statement, 0);
        }
        
    }
    return level;
    }
}

- (NSInteger)maxTopLevel
{
    NSString *sqlQuery =@"SELECT MAX(msgSet) FROM contactGroupTable";
    sqlite3_stmt * statement;
    int    level =0 ;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            level = sqlite3_column_int(statement, 0);
        }
        
    }
    return level;
}

#pragma mark - 群消息设置

- (BOOL)deleteGroupMsgTip:(NSString *)groupId
{
    return [self execSql:[NSString stringWithFormat:@"delete from messageReceiveSetTable where loginUserId = %@ and chatId=%@",[LoginUserUtil userId],groupId]];
}

- (BOOL)updateGroupMsgTip:(Enum_GroupMsgTipLevel)level withGroupId:(NSString *)groupId
{
    if([self deleteGroupMsgTip:groupId])
    {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'messageReceiveSetTable' ('chatId','type','loginUserId') VALUES ('%@', '%d', '%@')",groupId,(int)level,[LoginUserUtil userId]];
        return [self execSql:sql];
    }
    return YES;
}

- (Enum_GroupMsgTipLevel)tipLevel:(NSString *)groupId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"select type from messageReceiveSetTable where chatId = '%@' and loginUserId = '%@'",groupId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
           NSString *type = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            return (Enum_GroupMsgTipLevel)[type intValue];
        }
    }
    return GroupMsgTipLevel_ReceiveAndTip;
}


#pragma mark - 联系人

- (BOOL)clearContactTable
{
    if( [self execSql:[NSString stringWithFormat:@"delete from contactGroupTable"]])
    {
     return [self execSql:[NSString stringWithFormat:@"delete from contactGroupMemeberTable"]];
    }
    return NO;
}


- (BOOL)clearContactTableWithGroupId:(NSString *)groupId
{
    return [self execSql:[NSString stringWithFormat:@"delete from contactGroupMemeberTable where loginUserId = '%@' and loginUserType = '%@' and groupId= '%@'",[LoginUserUtil userId], [LoginUserUtil userType], groupId]];
}

- (BOOL)clearGroupTableWithGroupId:(NSString *)groupId
{
    return [self execSql:[NSString stringWithFormat:@"delete from contactGroupTable where loginUserId = '%@' and groupId = '%@'",[LoginUserUtil userId],groupId]];

}

//保存联系人到数据库
- (BOOL)saveContactToDB:(ADTIMContacter *)member
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'contactGroupMemeberTable' ('groupId', 'userId', 'name','mid','remoteId','type','role','dn','shortdn','loginUserId','loginType','loginUserType','studentid','studentname','student_relation','isOpen_phone', 'pinyin') VALUES ('%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",member.m_strGroupId,member.m_strId,member.m_strName,member.m_strMid,member.m_strRemoteId,member.m_strType,member.m_strRole,member.m_strDn,member.m_strShortDn,[LoginUserUtil userId],member.m_strLoginType, [LoginUserUtil userType],member.m_studentid,member.m_studentname,member.m_student_relation,member.m_isOpen_phone ? @"1" : @"0",member.m_pinyin];
    return [self execSql:sql];
}

//保存群组
- (BOOL)saveGroupToDB:(ADTIMGroup *)group
{
    [self clearGroupTableWithGroupId:group.m_strGroupId];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'contactGroupTable' ('groupId', 'id', 'groupName','hasshortdn','schoolname','role','type','loginUserId','newclassid','studentnum') VALUES ('%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@')",group.m_strGroupId,group.m_strId,group.m_strGroupName,group.m_isHasShortDn ? @"1" : @"0",group.m_strSchoolName,group.m_strRole,group.m_strType,[LoginUserUtil userId],group.m_strNewClassId,group.m_stuNum];
    return [self execSql:sql];
}

- (NSArray *)queryAllContact:(NSString *)key
{
    @synchronized(self)
    {
    NSString *sqlQuery = nil;
    if(key.length > 0)
    {
        sqlQuery = [NSString stringWithFormat:@"select  * from contactGroupMemeberTable where name like '%%%@%%' and loginUserId = '%@' and loginUserType = '%@'",key,[LoginUserUtil userId], [LoginUserUtil userType]];
    }
    else
    {
        sqlQuery = [NSString stringWithFormat:@"select  * from contactGroupMemeberTable where  loginUserId = '%@' and loginUserType = '%@'",[LoginUserUtil userId], [LoginUserUtil userType]];
    }
 
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[ADTIMContacter alloc]init];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid                 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType            = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            member.m_isSearch           = NO;
            member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            member.m_studentid        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding];
            member.m_studentname         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding];
            member.m_student_relation        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
            NSString  * v ;
            v = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            if ([v isEqualToString:@"1"]) {
                member.m_isOpen_phone = YES;
            } else {
                member.m_isOpen_phone = NO;
            }
            member.m_pinyin             =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];
            member.m_firstChar = [member.m_pinyin characterAtIndex:0];
            [arr addObject:member];
            [member release];
        }
    }
    
    return [arr autorelease];
    }
}

- (NSArray *)queryAllContact
{
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"select  * from contactGroupMemeberTable where loginUserId = '%@' and loginUserType = '%@'",[LoginUserUtil userId], [LoginUserUtil userType]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[ADTIMContacter alloc]init];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid                 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType            = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            member.m_studentid        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding];
            member.m_studentname         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding];
            member.m_student_relation        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
            NSString  * v ;
            v = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            if ([v isEqualToString:@"1"]) {
                member.m_isOpen_phone = YES;
            } else {
                member.m_isOpen_phone = NO;
            }
            member.m_pinyin             =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];
            member.m_firstChar = [member.m_pinyin characterAtIndex:0];

            member.m_isSearch           = NO;
            [arr addObject:member];
            [member release];
        }
    }
    
    return [arr autorelease];
    }
}


- (NSArray *)queryAllContactCanBeInvited
{
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"select * from contactGroupMemeberTable where loginUserId = '%@' and loginUserType = '%@' and  loginType != '1'",[LoginUserUtil userId], [LoginUserUtil userType]];
        sqlite3_stmt * statement;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ADTIMContacter *member       = [[ADTIMContacter alloc]init];
                member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                member.m_strMid                 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                member.m_strType            = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
                member.m_strDn             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
                member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
                member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
                member.m_studentid        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding];
                member.m_studentname         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding];
                member.m_student_relation        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
                
                NSString  * v ;
                v = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
                if ([v isEqualToString:@"1"]) {
                    member.m_isOpen_phone = YES;
                } else {
                    member.m_isOpen_phone = NO;
                }
                member.m_pinyin             =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];
                member.m_firstChar = [member.m_pinyin characterAtIndex:0];
                member.m_isSearch           = NO;
                [arr addObject:member];
                [member release];
            }
        }
        return [arr autorelease];
    }
}

- (BOOL)updataContactLoginType:(NSString *)strType withID:(NSString *)strId{
    return [self execSql: [NSString stringWithFormat:@"update contactGroupMemeberTable set loginType = '%@' where userId = '%@' and loginUserId = '%@' and loginUserType = '%@'",strType,strId,[LoginUserUtil userId], [LoginUserUtil userType]]];
}


- (NSArray *)queryAllContactFromDBWith:(NSString *)groupID
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"select  * from contactGroupMemeberTable where groupId = '%@' and loginUserId = '%@'",groupID,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[ADTIMContacter alloc]init];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:
                                           NSUTF8StringEncoding];
            member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            member.m_studentid        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding];
            member.m_studentname         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding];
            member.m_student_relation        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
            
            NSString  * v ;
            v = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
            if ([v isEqualToString:@"1"]) {
                member.m_isOpen_phone = YES;
            } else {
                member.m_isOpen_phone = NO;
            }
            member.m_pinyin             =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding];
            member.m_firstChar = [member.m_pinyin characterAtIndex:0];
            [arr addObject:member];
            [member release];
        }
    }
    
    return [arr autorelease];
    }
}

- (NSArray *)queryAllGroupFromDB
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM contactGroupTable where loginUserId = '%@'",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMGroup *group = [[[ADTIMGroup alloc]init]autorelease];
            group.m_strGroupId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            group.m_strId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            group.m_strGroupName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            group.m_isHasShortDn = [[NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]isEqualToString:@"1"];
            group.m_strSchoolName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            group.m_strRole = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            group.m_strType = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            group.m_strNewClassId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            group.m_stuNum = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 9) encoding:NSUTF8StringEncoding];
            [group getMemberArray];
            //[arr addObject:group];
            for (ADTIMContacter *contact in group.m_arrMember) {
                if ([[LoginUserUtil userId] isSubstringOf:contact.m_strId CaseSensitive:YES]) {
                    NSString *str = [NSString stringWithFormat:@"%d", [LoginUserUtil isTeacher]?2:1];
                    if ([contact.m_strType isEqualToString:str]) {
                        [arr addObject:group];
                        break;
                    }
//                    else{
//                        break;
//                    }
                }
            }
            
        }
    }
    
    return [arr autorelease];
    }
}

//只有当两个表同时没有数据时才去请求
- (BOOL) isNeedQueryContactsAndGroupData
{
    BOOL isGroupTableNeed = NO;
    BOOL isMemberTableNeed = NO;
    NSString *sqlQuery1 = [NSString stringWithFormat:@"SELECT * FROM contactGroupTable where loginUserId = %@",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    int num = 0 ;
    if (sqlite3_prepare_v2(m_db, [sqlQuery1 UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
           num++;
        }
        
    }
    isGroupTableNeed = (num == 0) ? YES : NO;
    
    num = 0;
    
    NSString *sqlQuery2 = [NSString stringWithFormat:@"SELECT * FROM contactGroupMemeberTable where loginUserId = %@ and loginUserType = '%@'",[LoginUserUtil userId], [LoginUserUtil userType]];
    if (sqlite3_prepare_v2(m_db, [sqlQuery2 UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            num++;
        }
        
    }
    
    
    isMemberTableNeed = (num == 0) ? YES : NO;
    return (isGroupTableNeed&&isMemberTableNeed);
}

//找到某个群组信息
- (ADTIMGroup *)queryGroupWith:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM contactGroupTable where groupId= '%@' and loginUserId = '%@'", groupId, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMGroup *group = [[ADTIMGroup alloc]init];
            group.m_strGroupId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            group.m_strId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            group.m_strGroupName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            group.m_isHasShortDn = [[NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]isEqualToString:@"1"];
            group.m_strSchoolName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            group.m_strRole = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            group.m_strType = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [group getMemberArray];
            return [group autorelease];
        }
    }
    
    return nil;
    }
}
//找到某个群组信息
- (ADTIMGroup *)queryGroupWithId:(NSString *)strId
{
    @synchronized(self)
    {
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM contactGroupTable where id= '%@' and loginUserId = '%@'", strId, [LoginUserUtil userId]];
        sqlite3_stmt * statement;
        if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ADTIMGroup *group = [[ADTIMGroup alloc]init];
                group.m_strGroupId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                group.m_strId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                group.m_strGroupName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                group.m_isHasShortDn = [[NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding]isEqualToString:@"1"];
                group.m_strSchoolName = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                group.m_strRole = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                group.m_strType = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
                [group getMemberArray];
                return [group autorelease];
            }
        }
        
        return nil;
    }
}


- (long)numOfGroupMember:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery1 =[NSString stringWithFormat:@"SELECT membersCount FROM contactGroupTable where  groupId = '%@' and loginUserId = '%@'", groupId, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    int num = 0 ;
    if (sqlite3_prepare_v2(m_db, [sqlQuery1 UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            num   =   sqlite3_column_int(statement, 0);
        }
    }
    
    return num;
    }

}

- (NSString *)nameOfGroup:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery1 =[NSString stringWithFormat:@"SELECT groupName FROM contactGroupTable where  groupId = '%@' and loginUserId = '%@'", groupId, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSString * str= nil;
    if (sqlite3_prepare_v2(m_db, [sqlQuery1 UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            str = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
        }
    }
    
    return str;
    }
}


- (NSArray *)queryContactsWithUserId:(NSString *)userId
{
    @synchronized(self)
    {
    NSString *sqlQuery1 =[NSString stringWithFormat:@"SELECT * FROM contactGroupMemeberTable where  userId = '%@' and loginUserId = '%@' and loginUserType = '%@'", userId, [LoginUserUtil userId], [LoginUserUtil userType]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [NSMutableArray array];
    if (sqlite3_prepare_v2(m_db, [sqlQuery1 UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[[ADTIMContacter alloc]init]autorelease];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            [arr addObject:member];
            return arr;
        }
    }
    return nil;
    }
}

- (ADTIMContacter *)queryChaterWithUserId:(NSString *)userId
{
    @synchronized(self)
    {
    NSString *sqlQuery1 =[NSString stringWithFormat:@"SELECT * FROM contactGroupMemeberTable where  userId = '%@' and loginUserId = '%@' and loginUserType = '%@'", userId, [LoginUserUtil userId], [LoginUserUtil userType]];
    sqlite3_stmt * statement;

        if (sqlite3_prepare_v2(m_db, [sqlQuery1 UTF8String], -1, &statement, nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ADTIMContacter *member       = [[[ADTIMContacter alloc]init]autorelease];
                member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                member.m_strMid         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                member.m_strType          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
                member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
                member.m_strDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
                member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
                member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
                member.m_studentid        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding];
                member.m_studentname         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding];
                member.m_student_relation        = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding];
                NSString  * v ;
                v = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding];
                if ([v isEqualToString:@"1"]) {
                    member.m_isOpen_phone = YES;
                } else {
                    member.m_isOpen_phone = NO;
                }

                return member;
            }
        }
    return nil;
    }
}


- (BOOL)isExistedGroupWith:(NSString *)groupId
{
    @synchronized(self)
    {
    NSString *sqlQuery =[NSString stringWithFormat:@"SELECT groupId FROM contactGroupTable where loginUserId = '%@' and groupId = '%@'",[LoginUserUtil userId],groupId];
    sqlite3_stmt * statement;
    int num = 0;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            num =  sqlite3_column_int(statement, 0);
        }
    }
    return num == 0 ? NO : YES;
    }
}


- (NSArray *)queryContacterWith:(NSString *)charString
{
    @synchronized(self)
    {
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM contactGroupMemeberTable where  name like '%%%@%%' and loginUserId = %@ and loginUserType = '%@' and groupId == '0'",charString,[LoginUserUtil userId],[LoginUserUtil userType]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[ADTIMContacter alloc]init];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            member.m_strLoginType         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding];
            [arr addObject:member];
            [member release];
        }
    }
    
    return [arr autorelease];
    }
}

#pragma mark -  查询某个用户d的属性


#pragma mark - 用户密码 
- (BOOL)insertUserTB:(NSString *)usreName withPassword:(NSString *)pwd withUserId:(NSString *)userId withUserType:(NSString *)type
{
    [self deleteUserWithName:usreName];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userTable' ('userName', 'passWord' ,'userId','userType','headUrl') VALUES ('%@', '%@','%@','%@','%@')",usreName,pwd,[LoginUserUtil userId],type,[[LoginUserUtil headUrl]absoluteString]];
    return [self execSql:sql];
}

- (BOOL)deleteUserWithName:(NSString *)name
{
    return [self execSql: [NSString stringWithFormat:@"delete from userTable where userName = '%@'",name]];
}

- (BOOL)deleteAllUser
{
    return [self execSql:@"delete from userTable"];
}

- (NSArray *)queryAllUser
{
    NSString *sqlQuery = @"SELECT * FROM userTable ";
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic =[[ NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding] forKey:@"userName"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"passWord"];
             [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] forKey:@"userId"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding] forKey:@"userType"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding] forKey:@"headUrl"];
            [arr addObject:dic];
            [dic release];
        }
        
        return arr;
    }
    
    return nil;
}

- (BOOL)updateUserWithName:(NSString *)newName withUserId:(NSString *)userId
{
    return [self execSql: [NSString stringWithFormat:@"update userTable set userName = '%@' where userId = '%@'",newName,userId]];
}

- (BOOL)updateUserWithPassword:(NSString *)newPwd withName:(NSString *)newName
{
    return [self execSql: [NSString stringWithFormat:@"update userTable set passWord = '%@' ,userId='%@'  where userName = '%@'",newPwd,newPwd,newName]];
}

#pragma mark - 特色应用
//获取所有特色应用
- (NSArray *)queryAllAddedApps
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where  userId =%@ and isAdd = 1",@"selectedAppTable",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            NSString *index = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [dic setObject:index forKey:@"funId"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding]forKey:@"name"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"isAdd"];
            [arr addObject:dic];
        }
    }
    return arr;
}

//获取所有特色应用
- (NSArray *)queryAllApps
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where  userId =%@",@"selectedAppTable",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            NSString *index = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [dic setObject:index forKey:@"funId"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding]forKey:@"name"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"isAdd"];
            [arr addObject:dic];
        }
    }
    return arr;
}

- (BOOL)isInsertedFun
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where  userId =%@",@"selectedAppTable",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            [arr addObject:dic];
        }
    }
   return arr.count != 0;
}

//增加一个应用纪录
- (BOOL)addAnApp:(NSString *)appId
{
    NSString *sql = [NSString stringWithFormat:@"update selectedAppTable set isAdd = '1'  where funId = '%@' and userId = '%@'",appId,[LoginUserUtil userId]];
    return [self execSql:sql];
}

//删除一个应用纪录
- (BOOL)deleteAnApp:(NSString *)appId
{
    return  [self execSql: [NSString stringWithFormat:@"delete from selectedAppTable where name = '%@' and userId = '%@'",appId,[LoginUserUtil userId]]];
}


//此应用是否已在数据库中
- (BOOL)isSaveInDBWith:(NSString *)appId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM selectedAppTable where isAdd = '1' and name = '%@' and userId = '%@'",appId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            return YES;
        }
    }
    
    sqlQuery = [NSString stringWithFormat:@"SELECT * FROM selectedAppTable where isAdd = '1' and funId = '%@' and userId = '%@'",appId,[LoginUserUtil userId]];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            return YES;
        }
    }
    return NO;
}

//增加一个应用纪录
- (BOOL)insertApp:(NSString *)appId name : (NSString *)name isAdd:(BOOL)flag
 {
     NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'selectedAppTable' ( 'funId' ,'name','isAdd','userId') VALUES ('%@','%@', '%@','%@')",appId,name,flag ? @"1" : @"0",[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (BOOL)addDefaultFun
{
     if(![self isInsertedFun])
     {
             for(int i=0;i<7;i++)
             {
                 switch (i) {
                     case 0:
                     {
                         [self insertApp:@"1" name:@"我的日志" isAdd:YES];
                          break;
                     }
                         
                     case 1:
                     {
                         [self insertApp:@"2" name:@"我的相册" isAdd:YES];
                         break;
                     }
                     case 2:
                     {
                         [self insertApp:@"3" name:@"我的微博" isAdd:YES];
                         break;
                     }
                     case 3:
                     {
                         [self insertApp:@"4" name:@"我的求助" isAdd:YES];
                         break;
                     }
                     case 4:
                     {
                         [self insertApp:@"5" name:@"通知公告" isAdd:NO];
                         break;
                     }
                     case 5:
                     {
                         [self insertApp:@"6" name:@"通讯录" isAdd:NO];
                         break;
                     }
                     case 6:
                     {
                         [self insertApp:@"7" name:@"我的回答" isAdd:NO];
                         break;
                     }
                     default:
                         break;
                 }
             }
  
     }
    return YES;
}


#pragma mark - 我的应用改版

- (NSArray *)allInsertedApp
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where  userId =%@",@"myAppTable",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            
           [dic setObject: [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0)  encoding:NSUTF8StringEncoding]forKey:@"appAuth"];
           [dic setObject: [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1)  encoding:NSUTF8StringEncoding]forKey:@"appCapture"];
           [dic setObject: [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding] forKey:@"appLauncher"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] forKey:@"appOpenFlag"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding] forKey:@"appPath"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding] forKey:@"appType"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding] forKey:@"appVersion"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding] forKey:@"app_sort"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding] forKey:@"appdesc"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 9) encoding:NSUTF8StringEncoding] forKey:@"applogo"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 10) encoding:NSUTF8StringEncoding] forKey:@"client_secret"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 11) encoding:NSUTF8StringEncoding] forKey:@"clientid"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 12) encoding:NSUTF8StringEncoding] forKey:@"create_time"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 13) encoding:NSUTF8StringEncoding] forKey:@"create_user"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 14) encoding:NSUTF8StringEncoding] forKey:@"del_mark"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 15) encoding:NSUTF8StringEncoding] forKey:@"id"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 16) encoding:NSUTF8StringEncoding] forKey:@"is_online"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 17) encoding:NSUTF8StringEncoding] forKey:@"link"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 18) encoding:NSUTF8StringEncoding] forKey:@"name"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 19) encoding:NSUTF8StringEncoding] forKey:@"sdepict"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 20) encoding:NSUTF8StringEncoding] forKey:@"sort_no"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 21) encoding:NSUTF8StringEncoding] forKey:@"usercount"];
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 22) encoding:NSUTF8StringEncoding] forKey:@"viewrole"];
            [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 23) encoding:NSUTF8StringEncoding] forKey:@"starttype"];
            
           [dic setObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, 24) encoding:NSUTF8StringEncoding] forKey:@"userId"];
            
           [arr addObject:dic];
            
        }
    }
    return arr;
}

- (void)insertApp:(NSDictionary *)appInfo
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'myAppTable' ( 'appAuth' ,'appCapture','appLauncher','appOpenFlag','appPath','appType','appVersion' ,'app_sort','appdesc','applogo','client_secret','clientid','create_time' ,'create_user','del_mark','id','is_online','link','name' ,'sdepict','sort_no','usercount','viewrole','starttype','userId') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",appInfo[@"appAuth"],appInfo[@"appCapture"],appInfo[@"appLauncher"],appInfo[@"appOpenFlag"],appInfo[@"appPath"],appInfo[@"appType"],appInfo[@"appVersion"],appInfo[@"app_sort"],appInfo[@"appdesc"],appInfo[@"applogo"],appInfo[@"client_secret"],appInfo[@"clientid"],appInfo[@"create_time"],appInfo[@"create_user"],appInfo[@"del_mark"],appInfo[@"id"],appInfo[@"is_online"],appInfo[@"link"],appInfo[@"name"],appInfo[@"sdepict"],appInfo[@"sort_no"],appInfo[@"usercount"],appInfo[@"viewrole"],appInfo[@"starttype"],[LoginUserUtil userId]];
   [self execSql:sql];
}

- (void)deleteApp:(NSString *)appId
{
    [self execSql: [NSString stringWithFormat:@"delete from myAppTable where id = '%@' and userId = '%@'",appId,[LoginUserUtil userId]]];
}

- (BOOL)isInserted:(NSString *)appId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM myAppTable where id = '%@' and userId = '%@'",appId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)updateAppLink:(NSDictionary *)info
{
    //NSString *sql = [NSString stringWithFormat:@"update selectedAppTable set isAdd = '1'  where funId = '%@' and userId = '%@'",appId,[LoginUserUtil userId]];
 return   [self execSql: [NSString stringWithFormat:@"update  myAppTable set link = '%@' where id = '%@' and userId = '%@'",info[@"link"],info[@"id"],[LoginUserUtil userId]]];
}

#pragma mark - 微课播放历史
- (BOOL)insertPlayHistory:(NSString *)videoId WithCover:(NSString *)coverUrl WithTitle:(NSString *)videoTitle WithTime:(NSString *)playTime
{
    //    NSString *videoPlayHistoryTable = @"CREATE TABLE IF NOT EXISTS 'videoPlayHistoryTable' (videoId TEXT,cover TEXT,videoTitle TEXT,userId LONG)";

    [self deleteVideoHistoryWith:videoId];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'videoPlayHistoryTable' ( 'videoId' ,'cover','videoTitle','playTime','userId') VALUES ('%@','%@', '%@','%@','%@')",videoId,coverUrl,[videoTitle stringByReplacingOccurrencesOfString:@"'" withString:@""""],playTime,[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (BOOL)deleteVideoHistoryWith:(NSString *)videoId
{
    return [self execSql: [NSString stringWithFormat:@"delete from videoPlayHistoryTable where videoId = '%@' and userId= '%@'",videoId,[LoginUserUtil userId]]];
}

- (NSArray *)queryAllVideoHistory
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ where  userId =%@",@"videoPlayHistoryTable",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
            NSString *videoId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            NSString *cover = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            NSString *videoTitle = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *playTime = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];

            [dic setObject:videoId forKey:@"videoId"];
            [dic setObject:cover forKey:@"cover"];
            [dic setObject:videoTitle forKey:@"videoTitle"];
            [dic setObject:playTime forKey:@"playTime"];
            [arr addObject:dic];
        }
    }
    return arr;
}

#pragma mark -  未做完作业
- (BOOL)saveUnCompletedHomework:(NSString *)content WithStudentId:(NSString *)studentId WithQuestionId:(NSString *)questionId
{
    [self deleteRecordWith:questionId];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'unCompletedHomeworkTable' ( 'questionId','studentId','content','userId') VALUES ('%@','%@','%@','%@')",questionId,studentId,content,[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (NSDictionary *)unCompletedHomeworkWith:(NSString *)questionId WithStudentId:(NSString *)studentId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM unCompletedHomeworkTable where questionId = '%@' and studentId = '%@' and  userId =%@",questionId,studentId,[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *content = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            return [content objectFromJSONString];
        }
    }
    return nil;
}

- (BOOL)deleteRecordWith:(NSString *)questionId
{
    return [self execSql: [NSString stringWithFormat:@"delete from unCompletedHomeworkTable where questionId = '%@' and userId= '%@'",questionId,[LoginUserUtil userId]]];

}

#pragma mark - @答疑
- (ADTChatMessage *)queryQuestionMsg
{
    NSString *  sqlQuery = [NSString stringWithFormat:@"SELECT msgId,m_strTime  FROM messageTable where m_contentType  = %d and loginUserId = %@ Order by ID Desc",ENUM_MSG_TYPE_ASK_AT, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    
    ADTChatMessage *tempMsg = [[[ADTChatMessage alloc]init]autorelease];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *content = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            tempMsg.m_msgid = content;
            
            NSString *time = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            tempMsg.m_strTime = time;
            
            tempMsg.m_contentType = ENUM_MSG_TYPE_ASK_AT;
            return tempMsg;
        }
    }
    return nil;
}

- (NSArray *)queryAllAnswerAT
{
    NSString *  sqlQuery = [NSString stringWithFormat:@"SELECT msgId,m_strTime  FROM messageTable where m_contentType  = %d and loginUserId = %@",ENUM_MSG_TYPE_ASK_AT, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTChatMessage *tempMsg = [[[ADTChatMessage alloc]init]autorelease];
            NSString *content = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            tempMsg.m_msgid = content;
            NSString *time = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            tempMsg.m_strTime = time;
            tempMsg.m_strMessageBody = @"有好友@您,邀请您回答问题";
            tempMsg.m_isFromSelf = ENUM_MESSAGEFROM_OPPOSITE;
            tempMsg.m_contentType = ENUM_MSG_TYPE_ASK_AT;
            tempMsg.m_timeLabState = ENUM_TIMELAB_STATE_SHOW;
            [arr addObject:tempMsg];
        }
    }
    return arr;
}

#pragma mark - 家校圈的通知草稿

- (BOOL)saveUnsendNotice:(NSDictionary *)noticeInfo
{
    [self deleteNotice];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'homeAndSchoolNoticeUnSendTable' ( 'groupIds','groupNames','content','picPaths','aduioPath','aduioDuration','saveTime','loginUserId') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",noticeInfo[@"groupIds"],noticeInfo[@"groupNames"],noticeInfo[@"content"],noticeInfo[@"picPaths"],noticeInfo[@"aduioPath"],noticeInfo[@"aduioDuration"],noticeInfo[@"saveTime"],[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (BOOL)deleteNotice
{
    return [self execSql: [NSString stringWithFormat:@"delete from homeAndSchoolNoticeUnSendTable where loginUserId= '%@'",[LoginUserUtil userId]]];
}

- (NSDictionary *)queryUnSendNoticeInfo
{
    NSString *  sqlQuery = [NSString stringWithFormat:@"SELECT *  FROM homeAndSchoolNoticeUnSendTable where loginUserId = %@", [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    
    NSMutableDictionary *retDic = [NSMutableDictionary  dictionary];
    
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *column0 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [retDic setObject:column0 forKey:@"groupIds"];
            
            NSString *column1 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            [retDic setObject:column1 forKey:@"groupNames"];
            
            NSString *column2 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            [retDic setObject:column2 forKey:@"content"];
            
            NSString *column3 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            [retDic setObject:column3 forKey:@"picPaths"];
            
            NSString *column4 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            [retDic setObject:column4 forKey:@"aduioPath"];
            
            NSString *column5 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            [retDic setObject:column5 forKey:@"aduioDuration"];
            
            NSString *column6 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [retDic setObject:column6 forKey:@"saveTime"];
            
            NSString *column7 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            [retDic setObject:column7 forKey:@"loginUserId"];
        }
    }
    
    [retDic setObject:@"1" forKey:@"isSaveMsg"];

    return retDic.allKeys.count == 1 ? nil : retDic;
}

#pragma mark - 家校圈的作业草稿

- (BOOL)saveUnsendHomework:(NSDictionary *)noticeInfo;
{
    [self deleteHomework];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'homeAndSchoolHomeworkUnSendTable' ( 'groupIds','groupNames', 'subjectid', 'subjectname', 'content','picPaths','aduioPath','aduioDuration','saveTime','loginUserId') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",noticeInfo[@"groupIds"],noticeInfo[@"groupNames"],noticeInfo[@"subjectid"],noticeInfo[@"subjectname"],noticeInfo[@"content"],noticeInfo[@"picPaths"],noticeInfo[@"aduioPath"],noticeInfo[@"aduioDuration"],noticeInfo[@"saveTime"],[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (BOOL)deleteHomework
{
    return [self execSql: [NSString stringWithFormat:@"delete from homeAndSchoolHomeworkUnSendTable where loginUserId= '%@'",[LoginUserUtil userId]]];
}

- (NSDictionary *)queryUnSendHomeworkInfo
{
    NSString *  sqlQuery = [NSString stringWithFormat:@"SELECT * FROM homeAndSchoolHomeworkUnSendTable where loginUserId = %@", [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    
    NSMutableDictionary *retDic = [NSMutableDictionary  dictionary];
    
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            // // CREATE TABLE 'homeAndSchoolHomeworkUnSendTable'(groupIds TEXT,groupNames  TEXT ,subjectid TEXT,subjectname TEXT,content TEXT,picPaths TEXT,aduioPath TEXT,aduioDuration TEXT,saveTime TEXT,loginUserId TEXT)
            NSString *column0 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [retDic setObject:column0 forKey:@"groupIds"];
            
            NSString *column1 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            [retDic setObject:column1 forKey:@"groupNames"];
            
            NSString *column1_2 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            [retDic setObject:column1_2 forKey:@"subjectid"];
            
            NSString *column1_3 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            [retDic setObject:column1_3 forKey:@"subjectname"];
            
            NSString *column2 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            [retDic setObject:column2 forKey:@"content"];
            
            NSString *column3 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            [retDic setObject:column3 forKey:@"picPaths"];
            
            NSString *column4 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            [retDic setObject:column4 forKey:@"aduioPath"];
            
            NSString *column5 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            [retDic setObject:column5 forKey:@"aduioDuration"];
            
            NSString *column6 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            [retDic setObject:column6 forKey:@"saveTime"];
            
            NSString *column7 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 9) encoding:NSUTF8StringEncoding];
            [retDic setObject:column7 forKey:@"loginUserId"];
        }
    }
    
    [retDic setObject:@"1" forKey:@"isSaveMsg"];
    
    return retDic.allKeys.count == 1 ? nil : retDic;
}

//保存发送人信息
- (BOOL)saveHomeAndSchoolSendInfo:(HomeAndSchoolSendInfoDTO *)dto {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'homeAndSchoolSendInfoTable' (userIds , userNames , classroomIds ,classroomNames , groupTypeIds , userGroupTypes ,groupTypes ,sendType ,subjectiveName ,subjectiveId ,userId) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dto.userIds,dto.userNames,dto.classroomIds,dto.classroomNames,dto.groupTypeIds,dto.userGroupTypes,dto.groupTypes,dto.sendType,dto.subjectiveName,dto.subjectiveId,[NSString stringWithFormat:@"%@",[LoginUserUtil userId]]];
    
    return [self execSql:sql];
    
}

- (HomeAndSchoolSendInfoDTO *)queryHomeAndSchoolSendInfo:(NSString *)sendType {
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM homeAndSchoolSendInfoTable WHERE userId = '%@' AND sendType = '%@'",[NSString stringWithFormat:@"%@",[LoginUserUtil userId]] ,sendType];
    //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM friendTable"];// (friendName like '%%%@%%' OR friend like '%%%@%%') And userId = '%@'",friendname,friendPhone,userId];
    
    sqlite3_stmt *statment;
    HomeAndSchoolSendInfoDTO *infoDto = [[HomeAndSchoolSendInfoDTO alloc] init];
    if (sqlite3_prepare_v2(m_db, [sql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        while (sqlite3_step(statment) == SQLITE_ROW) {
            infoDto.userIds = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 0) encoding:NSUTF8StringEncoding];
            infoDto.userNames = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
            infoDto.classroomIds = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 2) encoding:NSUTF8StringEncoding];
            infoDto.classroomNames = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 3) encoding:NSUTF8StringEncoding];
            infoDto.groupTypeIds = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 4) encoding:NSUTF8StringEncoding];
            infoDto.userGroupTypes = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 5) encoding:NSUTF8StringEncoding];
            infoDto.groupTypes = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 6) encoding:NSUTF8StringEncoding];
            infoDto.sendType = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 7) encoding:NSUTF8StringEncoding];
            infoDto.subjectiveName = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 8) encoding:NSUTF8StringEncoding];
            infoDto.subjectiveId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 9) encoding:NSUTF8StringEncoding];
            
            //            SpeLog(@"name = %@ phone = %@",friendName,friendPhone);
        }
    }
    return [infoDto autorelease];
}

- (BOOL)deleteHomeAndSchoolSendInfoTable:(NSString *)sendType {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM homeAndSchoolSendInfoTable WHERE userId = '%@' AND sendType = '%@'",[NSString stringWithFormat:@"%@",[LoginUserUtil userId
                                                                                                                                                                   ]], sendType];
    return [self execSql:sql];
}


//用户自动登录信息
- (BOOL)saveUserAutoLoginInfo:(AutoLoginInfoDTO *)dto {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userAutoLoginInfoTable' (userName, password, userToken, isAutoLogin ,userId) VALUES ('%@','%@','%@','%@','%@')",dto.userName,dto.password,dto.token,dto.isAutoLogin,dto.userId];
    return [self execSql:sql];
    
}
- (AutoLoginInfoDTO *)queryUserAutoLoginInfo:(NSString *)userId {
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM userAutoLoginInfoTable WHERE userId = '%@'",userId];
    //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM friendTable"];// (friendName like '%%%@%%' OR friend like '%%%@%%') And userId = '%@'",friendname,friendPhone,userId];
    AutoLoginInfoDTO *autoLoginInfoDto = [[[AutoLoginInfoDTO alloc] init] autorelease];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(m_db, [sql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        while (sqlite3_step(statment) == SQLITE_ROW) {
            autoLoginInfoDto.userName = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 0) encoding:NSUTF8StringEncoding];
            autoLoginInfoDto.password = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
            autoLoginInfoDto.token = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 2) encoding:NSUTF8StringEncoding];
            autoLoginInfoDto.isAutoLogin = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 3) encoding:NSUTF8StringEncoding];
            autoLoginInfoDto.userId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 4) encoding:NSUTF8StringEncoding];
            //            SpeLog(@"name = %@ phone = %@",friendName,friendPhone);
        }
    }
    return autoLoginInfoDto;
    
}


- (BOOL)modifyUserAutoLoginInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue {
    NSString *sql = nil;
    sql =  [NSString stringWithFormat:@"UPDATE userAutoLoginInfoTable SET %@ = %@ WHERE userId = %@",lineName,lineValue,userId];
    
    return [self execSql:sql];
    
}


- (BOOL)deleteUserAutoLoginInfo:(NSString *)userId {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM userAutoLoginInfoTable WHERE userId = '%@'",userId];
    return [self execSql:sql];
}
//用户登录返回信息
- (BOOL)saveLoginUserReturnInfo:(LoginReturnInfoDTO *)dto {
    //    NSString *userName = dto.userName;
    NSString *userName = [dto.userName stringByReplacingOccurrencesOfString:@"'" withString:@"\\singlequote"];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userLoginReturnInfoTable' (userId, userName, orgin, avatar, userType, token, replyName ,creditScore, creditScoreEndtime, isSign, isChat) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dto.userId,userName,dto.orgin,dto.avatar,dto.userType,dto.token,dto.replyName,dto.creditScore,dto.creditScoreEndtime,dto.isSign,dto.isChat];
    return [self execSql:sql];
    
}
- (LoginReturnInfoDTO *)queryLoginUserReturnInfo:(NSString *)userId {
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM userLoginReturnInfoTable WHERE userId = '%@'",userId];
    //    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM friendTable"];// (friendName like '%%%@%%' OR friend like '%%%@%%') And userId = '%@'",friendname,friendPhone,userId];
    LoginReturnInfoDTO *loginReturnInfoDto = [[[LoginReturnInfoDTO alloc] init] autorelease];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(m_db, [sql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        while (sqlite3_step(statment) == SQLITE_ROW) {
            loginReturnInfoDto.userId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 0) encoding:NSUTF8StringEncoding];
            NSString *userNameUrl = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
            NSString* userName = [userNameUrl stringByReplacingOccurrencesOfString:@"\\singlequote" withString:@"'"];
            
            loginReturnInfoDto.userName = userName;//[NSString stringWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.orgin = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 2) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.avatar = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 3) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.userType = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 4) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.token = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 5) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.replyName = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 6) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.creditScore = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 7) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.creditScoreEndtime = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 8) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.isSign = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 9) encoding:NSUTF8StringEncoding];
            loginReturnInfoDto.isChat = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 10) encoding:NSUTF8StringEncoding];
            
            
            //            SpeLog(@"name = %@ phone = %@",friendName,friendPhone);
        }
    }
    return loginReturnInfoDto;
    
}

- (BOOL)modifyLoginUserReturnInfo:(NSString *)userId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue {
    NSString *sql = nil;
    sql =  [NSString stringWithFormat:@"UPDATE userLoginReturnInfoTable SET %@ = %@ WHERE userId = %@",lineName,lineValue,userId];
    
    return [self execSql:sql];
    
}

- (BOOL)deleteLoginuserreturnInfo:(NSString *)userId {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM userLoginReturnInfoTable WHERE userId = '%@'",userId];
    return [self execSql:sql];
}
//用户小孩信息
- (BOOL)saveUserChildrenInfo:(LoginUserChildrenInfoDTO *)dto {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userChildrenInfoTable' (childrenId, childrenName,parentId,childrenpPhone,ChildrenSchool,isActive, remoteId,className,cavatar,classId,kindRed,modifyDate,schoolName,sex,birthday,gradeid,gradename,schequipment) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",dto.childrenId,dto.childrenName,dto.parentId,dto.childrenpPhone,dto.ChildrenSchool,dto.isActive,dto.remoteId,dto.className, dto.childHeadImgUrl, dto.classId, dto.kindred, dto.modifyDate, dto.schoolName,dto.sex,dto.birthday,dto.gradeid,dto.gradename,dto.schequipment];
    return [self execSql:sql];
    
}
- (NSArray *)queryUserChildrenInfo:(NSString *)userId {
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM userChildrenInfoTable WHERE parentId = '%@'",userId];
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(m_db, [sql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        while (sqlite3_step(statment) == SQLITE_ROW) {
            LoginUserChildrenInfoDTO *loginUserChildrenInfoDto = [[LoginUserChildrenInfoDTO alloc] init];
            
            loginUserChildrenInfoDto.childrenId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 0) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.childrenName = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.parentId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 2) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.childrenpPhone = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 3) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.ChildrenSchool = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 4) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.isActive = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 5) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.remoteId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 6) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.className = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 7) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.childHeadImgUrl = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 8) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.classId = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 9) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.kindred = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 10) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.modifyDate= [NSString stringWithCString:(char *)sqlite3_column_text(statment, 11) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.schoolName = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 12) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.sex = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 13) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.birthday = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 14) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.gradeid = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 15) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.gradename = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 16) encoding:NSUTF8StringEncoding];
            loginUserChildrenInfoDto.schequipment = [NSString stringWithCString:(char *)sqlite3_column_text(statment, 17) encoding:NSUTF8StringEncoding];
            
            [arr addObject:loginUserChildrenInfoDto];
            
            [loginUserChildrenInfoDto release];
        }
    }
    return arr;;
    
}

- (BOOL)modifyUserChildrenInfo:(NSString *)childId ParentId:(NSString*)parentId lineNameStr:(NSString *)lineName lineValueStr:(NSString *)lineValue{
    NSString *sql = nil;
    sql =  [NSString stringWithFormat:@"UPDATE userChildrenInfoTable SET %@ = '%@' WHERE parentId = '%@' and childrenId = '%@'", lineName, lineValue, parentId, childId];
    
    return [self execSql:sql];
    
}

- (BOOL)deleteUserChildrenInfo:(NSString *)userId {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM userChildrenInfoTable WHERE parentId = '%@'",userId];
    return [self execSql:sql];
}

#pragma mark - 最近联系人

- (BOOL)insertHistoryContactWith:(ADTIMContacter *)contact
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'historyContactTable' ('groupId', 'userId', 'name','mid','remoteId','type','role','dn','shortdn','loginUserId','loginType') VALUES ('%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@')",contact.m_strGroupId,contact.m_strId,contact.m_strName,contact.m_strMid,contact.m_strRemoteId,contact.m_strType,contact.m_strRole,contact.m_strDn,contact.m_strShortDn,[LoginUserUtil userId],contact.m_strLoginType];
    return [self execSql:sql];
}

- (BOOL)deleteHistoryContactWith:(ADTIMContacter *)contact
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM historyContactTable WHERE userId = '%@' and loginUserId = '%@'",contact.m_strId,[LoginUserUtil userId]];
    return [self execSql:sql];
}

- (NSArray *)queryAllHistoryContacts
{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from historyContactTable where loginUserId = '%@'",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTIMContacter *member       = [[ADTIMContacter alloc]init];
            member.m_strGroupId             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            member.m_strId                  = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            member.m_strName                =   [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            member.m_strMid                 = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            member.m_strRemoteId          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
            member.m_strType            = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
            member.m_strRole          = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
            member.m_strDn             = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
            member.m_strShortDn         = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding];
            member.m_isSearch           = NO;
            //这边不要显示邀请按钮
            member.m_strLoginType         = @"2";
            [arr addObject:member];
            [member release];
        }
    }
    
    return [arr autorelease];
}

-(BOOL)clearUserOperations{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM userOperationsTable WHERE loginUserId = '%@'",[LoginUserUtil userId]];
    return [self execSql:sql];
}

-(BOOL)updateUserOperation:(NSString*)Key{
    
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from userOperationsTable where loginUserId = '%@' and userOpeations = '%@'",[LoginUserUtil userId], Key];
    sqlite3_stmt * statement;
    int  number = -1;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            number = sqlite3_column_int(statement, 2);
        }
    }
    
    if (number == -1) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userOperationsTable' ('loginUserId', 'userOpeations', 'number') VALUES ('%@', '%@', 1)",[LoginUserUtil userId],Key];
        return [self execSql:sql];
    }
    else{
        number++;
        NSString *sql = nil;
        sql =  [NSString stringWithFormat:@"UPDATE userOperationsTable SET number = %d WHERE loginUserId = '%@' and userOpeations = '%@'",number,[LoginUserUtil userId], Key];
        return [self execSql:sql];
    }
}

-(NSArray*)selectAllOperation{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from userOperationsTable where loginUserId = '%@'",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *key = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            int value = sqlite3_column_int(statement, 2);
            NSDictionary *dic = @{key:[NSNumber numberWithInt:value]};
            [arr addObject:dic];
        }
    }
    
    return [arr autorelease];
}

-(BOOL)updateNewMsg:(NewMsgModel*)newMsg{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from userNewMsgTable where type = '%@' and classid = '%@' and loginUserId = '%@'",newMsg.strType, newMsg.strClassId, [LoginUserUtil userId]];
    sqlite3_stmt * statement;
    int  number = -1;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            number = sqlite3_column_int(statement, 2);
        }
    }
    
    if (number == -1) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'userNewMsgTable' ('loginUserId', 'type', 'classid', 'id') VALUES ('%@', '%@', '%@', '%@')",[LoginUserUtil userId],newMsg.strType, newMsg.strClassId, newMsg.strId];
        return [self execSql:sql];
    }
    else{
        number++;
        NSString *sql = nil;
        sql =  [NSString stringWithFormat:@"UPDATE userNewMsgTable SET id = '%@' WHERE loginUserId = '%@' and type = '%@' and classid = '%@'", newMsg.strId,[LoginUserUtil userId],newMsg.strType,newMsg.strClassId];
        return [self execSql:sql];
    }
}
-(NewMsgModel*)getNewMsg:(NSString*)strType ClassId:(NSString*)strClassId{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from userNewMsgTable where loginUserId = '%@' and type = '%@' and classid = '%@'",[LoginUserUtil userId], strType, strClassId];
    sqlite3_stmt * statement;
    NewMsgModel *msg = nil;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            msg = [[NewMsgModel alloc]init];
            msg.strType = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            msg.strId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            msg.strClassId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            break;
        }
    }
    
    return [msg autorelease];
}

-(NSArray*)getNewMsgAll{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from userNewMsgTable where loginUserId = '%@'",[LoginUserUtil userId]];
    sqlite3_stmt * statement;
    
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NewMsgModel *msg = [[NewMsgModel alloc]init];
            msg.strType = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            msg.strId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
            msg.strClassId = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            
            [arr addObject:[msg autorelease]];
        }
    }
    return [arr autorelease];
}
@end
