//
//  LinkagePushUIApplication.h
//  xxt_xj
//
//  Created by points on 2017/5/23.
//  Copyright © 2017年 Points. All rights reserved.
//





#import "CommonCrypto/CommonDigest.h"
#include <CommonCrypto/CommonCryptor.h>
#import "VwtIMLib.h"
#import "VwtIMMessage.h"

//v网通
#define LA_PUSH_USERID             @"100000000"
#define SDK_VWT_APPID              @"10000005"
#define SDK_VWT_APPKEY             @"q9wBf22QXIOBeTFMzmyYJylGBtm80W7t1lqVt2MW7O32Ces38cpQtIdxBcs9ucOo"
#define SDK_VWT_VERSION            @"1.0"

//公司接口
#define LA_PUSH_ASYC_SERVER        @"http://pushapp.72ch.com:8000/licenter/app/push/loginOL"
#define LA_PUSH_ASYC_APPKEY        @"Test"
#define LA_PUSH_ASYC_HTTP_RAK      LA_PUSH_ASYC_APPKEY
#define LA_PUSH_ASYC_DES_SECRET    @"10000000"

#define LA_PUSH_DEVICE_KEY         @"LA_PUSH_DEVICE_KEY"

#import "LinkagePushUIApplication.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface LinkagePushUIApplication : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;


typedef void (^LAPushCallBack)(id result, id error);


/**
 获取默认单例执行对象

 @return AppDelegate
 */
LinkagePushUIApplication *getAppDelegate();

/**
 所有消息消息回调
 */
@property (nonatomic,strong)LAPushCallBack m_allMessagesCallback;


/**
 登录公司同步接口

 @param userId 用户id,各省份自己的用户id
 @param deviceId 设备id
 @param callback callback
 */
- (void)initAndAsync:(NSString *)userId
        withDeviceId:(NSString *)deviceId
        withCallBack:(LAPushCallBack)callback;


/**
 注销
 */
-(void) logout ;

/**
 断开连接
 */
-(void)disConnectIm;



#pragma mark - 消息接口

/**
 单聊消息

 @param text 上传接口返回的的字符串或者文本消息内容
 @param targetid     目标会话 ID
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 */
-(NSString *)sendMessage:(NSString *) text TargetId:(NSString *) targetid  MessageType:(VwtMessageType)messageType andWithExtendedField:(NSString *)extendedField success:(void (^)(id value))successBlock  error:(void (^)(VwtError* error))errorBlock;

/**
 群发消息

 @param msgContent   上传接口返回的的字符串或者文本消息内容
 @param targetidArr  目标会话 ID 数组
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 @param messageType 消息类型
 */
-(NSString *) sendBatchMessage:(NSString *) msgContent TargetId:(NSArray *) targetidArr MessageType:(VwtMessageType)messageType andWithExtendedField:(NSString *)extendedField success:(void (^)(id value))successBlock  error:(void (^)(VwtError* error))errorBlock;

/**
 群聊消息

 @param msgContent   上传接口返回的的字符串或者文本消息内容
 @param targetid     目标会话 ID
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 */
-(NSString *) sendMessageToGroup:(NSString *) msgContent TargetId:(NSString *) targetid MessageType:(VwtMessageType)messageType andWithExtendedField:(NSString *)extendedField success:(void (^)(id value))successBlock  error:(void (^)(VwtError* error))errorBlock;





/**
 上传文件

 @param FilePath 文件路径
 @param uploadLargeFileBlock 成功或者失败的块
 @param progess 上传进度
 @param timeout 超时时间
 */
-(void)uploadAttachment:(NSString*)FilePath andTimeout:(NSInteger)timeout uploadLargeFileBlock:(uploadLargeFileBlock)uploadLargeFileBlock
                progess:(void(^)(float progess))progess;

/**
 请求开始获取离线消息

 @param successBlock 返回success表示请求成功
 @param errorBlock  返回错误信息
 */
-(void) getOfflineMessage:(void (^)(NSString *value))successBlock  error:(void (^)(VwtError* error))errorBlock;

#pragma mark - 查询历史纪录

/**
 查询单人历史纪录

 @param userId       待查询的用户 ID
 @param sTime        查询的开始时间 如果客户端不写 则默认查询10天内的数据
 @param eTime        查询的结束时间 如果客户端不写 则默认查询到今天为止
 时间为 NSString.格式为 yyyyMMdd.
 例:2017年1月1日 20170101
 注意:函数内部已解决时差问题,外部不需要考虑.
 @param isGroup      是否查询群组.yes 为单人,no 为群组
 @param index        页数.第一次查询的时候不需要传入.后续查询需要传入该值
 @param successBlock 成功
 @param pageNum      分页条数.默认20.
 @param errorBlock   失败
 */
-(void) qryHisMessage:(NSString*)userId andStartTime:(NSString*)sTime andEndTime:(NSString*)eTime andIndex:(NSString*)index andPageNum:(NSString*)pageNum andIsGroup:(BOOL)isGroup success:(void (^)(VwtResponse *value))successBlock error:(void(^)(VwtError* error))errorBlock;



@end
