//
//  LinkagePushUIApplication.m
//  xxt_xj
//
//  Created by points on 2017/5/23.
//  Copyright © 2017年 Points. All rights reserved.
//

#import "LinkagePushUIApplication.h"



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface LinkagePushUIApplication()

@end


@implementation LinkagePushUIApplication
#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"succeeded!");
            }
        }];
        [application registerForRemoteNotifications];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.m_allMessagesCallback(userInfo, nil);
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    self.m_allMessagesCallback(userInfo, nil);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    self.m_allMessagesCallback(userInfo, nil);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"LA_PUSH_didRegisterForRemoteNotificationsWithDeviceToken:%@", pushToken);
    
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:LA_PUSH_DEVICE_KEY];
    
    
    [[VwtIMLib sharedInstance]registerForRemoteNotificationsWithDeviceToken:deviceToken];
    
}



#pragma mark - util function

+(NSString *) md5ForLAPush: (NSString *) inputString
{
    @try
    {
        const char *cStr = [inputString UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        
        return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
                 ] uppercaseString];
    }
    @catch (NSException *exception)
    {
        //        SpeLog(@"XXTmd5 exception:%@",exception);
    }
}



+ (NSData *)getDeviceToken
{
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:LA_PUSH_DEVICE_KEY];
    if(deviceToken == nil){
        
        NSString *token = @"4579374573947598374579345837485";
        deviceToken = [token dataUsingEncoding:NSUTF8StringEncoding];
    }
    return deviceToken;
}


- (NSString *)jsonValue:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

- (NSString *)getUdid
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    return uuidString;
}

- (NSString *)getRegisterId:(NSString *)userId
{
    unsigned long ran = random()%99999;
    return [NSString stringWithFormat:@"%@%@%ld",SDK_VWT_APPID,userId,ran];
}

- (void)sendMsg:(NSString *)targetId
{
    [[VwtIMLib sharedInstance]sendMessage:[[NSDate date]description]
                                 TargetId:targetId
                                RequestId:[self getUdid]
                              MessageType:VwtMessageTypeText
                     andWithExtendedField:nil success:^(id value) {
                         NSLog(@"sendSingleTextMessage成功->%@",value);
                         self.m_allMessagesCallback(value, nil);
                     } error:^(VwtError *error) {
                         NSLog(@"sendSingleTextMessage失败->%@",error);
                         self.m_allMessagesCallback(nil, error);
                     }];
    
}

- (void)getOfflineMsg
{
    [[VwtIMLib sharedInstance]getOfflineMessage:^(NSString *value) {
        
        NSLog(@"getOfflineMessage成功->%@",value);
        
        
    } error:^(VwtError *error) {
        NSLog(@"getOfflineMessage失败->%@",error);
    }];
}


static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    //      NSLog(@"[[item.url description] UTF8String=%@",textString);
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递decrypt 解码
    {
        //解码 base64
        //        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转utf-8并decode
        NSData *decryptData = [[NSData alloc]initWithBase64EncodedString:textString options:NSDataBase64DecodingIgnoreUnknownCharacters];;//
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //理解位type/typedef 缩写（效维护代码比：用int用long用typedef定义）
    size_t dataOutAvailable = 0; //size_t  操作符sizeof返结类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 00, dataOutAvailable);//已辟内存空间buffer首 1 字节值设值 0
    
    //NSString *initIv = @"12345678";
    const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪标准（des3desaes）
                       kCCOptionPKCS7Padding,//  选项组密码算(des:每块组加密  3DES：每块组加三同密)
                       vkey,  //密钥    加密解密密钥必须致
                       kCCKeySizeDES,//   DES 密钥（kCCKeySizeDES=8）
                       iv, //  选初始矢量
                       dataIn, // 数据存储单元
                       dataInLength,// 数据
                       (void *)dataOut,// 用于返数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //解密data数据改变utf-8字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密程加密数据转base64）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        //        result = [GTMBase64 stringByEncodingData:data];
        result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    return [result UTF8String];
    
}
-(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return  [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}

- (NSString *)DES_EncryptWithText:(NSString *)sText
{
    return [self encryptWithContent:sText type:kCCEncrypt key:LA_PUSH_ASYC_DES_SECRET];
}

- (NSString *)DES_DncodeWithText:(NSString *)sText
{
    return [self encryptWithContent:sText type:kCCDecrypt key:LA_PUSH_ASYC_DES_SECRET];
}


- (NSString*) sha1:(NSString *)userId
{
    const char *cstr = [userId UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:userId.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output.length > 20 ? [output substringToIndex:20] : output;
}

#pragma mark - public



/**
 登录公司同步接口
 
 @param userId 用户id,各省份自己的用户id
 @param deviceId 设备id
 @param callback callback
 */
- (void)initAndAsync:(NSString *)userId
        withDeviceId:(NSString *)deviceId
        withCallBack:(LAPushCallBack)callback
{
    NSMutableDictionary *insert = [NSMutableDictionary dictionary];
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    int num = (arc4random() % 100000000);
    NSString * random = [NSString stringWithFormat:@"%.8d", num];
    NSLog(@"%@", random);
    
    [insert setObject:@(timestamp) forKey: @"timestamp"];
    [insert setObject:random forKey: @"random"];
    
    [insert setObject:LA_PUSH_ASYC_APPKEY forKey: @"appKey"];
    
    
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    [object setObject:@"ios" forKey: @"deviceType"];
    [object setObject:userId forKey: @"userId"];
    [object setObject:deviceId forKey: @"deviceId"];
    
    //        [object setObject:SDK_VWT_APPKEY forKey: @"appKey"];
    //        [object setObject:LA_PUSH_USERID forKey: @"userId"];
    //        [object setObject:provice forKey: @"provice"];
    //        [object setObject:city forKey: @"city"];
    //        [object setObject:@"iOS" forKey: @"deviceType"];
    //        [object setObject:[self getRegisterId:userId]  forKey: @"registerId"];
    //        [object setObject:userRole forKey: @"userRole"];
    //        [object setObject:SDK_VWT_VERSION forKey: @"sdkversion"];
    //        [object setObject:appVersion forKey: @"appVersion"];
    
    [insert setObject:object forKey: @"object"];
    
    NSString *json = [self jsonValue:insert];
    NSString *strUrl = [json stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonDES = [self DES_EncryptWithText:strUrl];
    
    NSString *postBody = [NSString stringWithFormat:@"r_a_k=%@&r_b=%@",LA_PUSH_ASYC_HTTP_RAK,jsonDES];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LA_PUSH_ASYC_SERVER]];
    req.HTTPMethod = @"POST";
    req.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * __nullable response, NSData * __nullable data, NSError * __nullable connectionError) {
                               
                               // 4.解析服务器返回的数据
                               NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                               
                               NSLog(@"initAndAsync:sendAsynchronousRequest-->%@",str);
                               // 转换并打印响应头信息
                               NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                               NSLog(@"转换并打印响应头信息--%zd---%@--",res.statusCode,res.allHeaderFields);
                               
                               
                               
                               if(connectionError){
                                   callback(nil,connectionError);
                               }else{
                                   
                                   [self loginVWTServer:SDK_VWT_APPID
                                          withAppSecret:SDK_VWT_APPKEY
                                             withUserId:deviceId
                                           withCallBack:^(id result, NSError *error) {
                                               if(error == nil){//登录成功
                                                   callback(deviceId,nil);
                                               }else{//登录失败
                                                   callback(nil,error);
                                               }
                                               
                                           }];
                               }
                               
                               
                               
                               
                           }];
    
}


- (void)extracted:(VwtUserInfo *)vUserinfo {
    [[VwtIMLib sharedInstance] loginWithUserInfo:vUserinfo
                                         success:^(id value) {
                                             
                                             
                                             [[VwtIMLib sharedInstance]registerForRemoteNotificationsWithDeviceToken:[LinkagePushUIApplication getDeviceToken]];
                                             //登录成功
                                             NSLog(@"loginWithUserInfo成功-->%@",value);
                                             self.m_allMessagesCallback(value, nil);
                                         } error:^(VwtError * error) {
                                             NSLog(@"loginWithUserInfo->%@ sercerCode:%@,code:%ld",error.content,error.serverContent,(long)error.code);
                                             self.m_allMessagesCallback(error, error);
                                             
                                             //登录失败
                                         }];
}

/**
 连接v网通服务器
 
 @param appId
 @param appSecret
 @param userId 源自initAndAsync方法里
 */
- (void)loginVWTServer:(NSString *)appId
         withAppSecret:(NSString *)appSecret
            withUserId:(NSString *)userId
          withCallBack:(LAPushCallBack)callback{
    NSLog(@"loginVWTServer");
    VwtUserInfo * vUserinfo     = [[VwtUserInfo alloc] init] ;
    vUserinfo.appId             = appId;
    vUserinfo.appSecret         =  appSecret;
    vUserinfo.userId            = userId;
    
    
    [[VwtIMLib sharedInstance]registerForRemoteNotificationsWithDeviceToken:[LinkagePushUIApplication getDeviceToken]];
    
    //收到普通消息，也要回调
    vUserinfo.receivedMessageBlock = ^(VwtIMMessage* value) {
        NSLog(@"receivedMessageBlock->%@",[value content]);
        self.m_allMessagesCallback(value, nil);
    } ;
    
    //设置回调报错
    vUserinfo.receivedErrorBlock = ^(VwtError *error) {
        NSLog(@"receivedErrorBlock->%@ sercerCode:%@,code:%ld",error.content,error.serverContent,(long)error.code);
        
        if(error.code == VWT_LOGIN_SUCCESS)
        {
            [self getOfflineMsg];
            callback(error,nil);
        }
        else if (error.code == VWT_KICKED_OUT)
        {
            [[VwtIMLib sharedInstance]disConnectIm];
            [[VwtIMLib sharedInstance]logout];
        }
        self.m_allMessagesCallback(error,nil);
        
    };
    
    //设置服务号推送回调,
    //服务器的推送，也要回调
    vUserinfo.receivedServerPushBlock = ^(VwtServicePush *message) {
        NSLog(@"receivedErreceivedServerPushBlockrorBlock->%@",message.content);
        self.m_allMessagesCallback(message, nil);
    };
    
    //群聊信息变更回调
    vUserinfo.receivedGroupOperateBlock = ^(VwtTaskGroup *message) {
        
        NSLog(@"receivedGroupOperateBlock->%@",@"群聊信息变更回调");
        
    };
    
    [self extracted:vUserinfo] ;
    
}



/**
 断开与服务器的连接
 注销当前用户
 */
- (void)logoutVWTServer:(LAPushCallBack)callback;
{
    NSLog(@"logoutVWTServer");
    [[VwtIMLib sharedInstance] disConnectIm];
    [[VwtIMLib sharedInstance] logout];
    
}


LinkagePushUIApplication *getAppDelegate()
{
    UIApplication *application = [UIApplication sharedApplication];
    LinkagePushUIApplication *app = (LinkagePushUIApplication *)application.delegate;
    return app;
}


#pragma mark - 消息接口

/**
 注销
 */
-(void) logout {
    [[VwtIMLib sharedInstance]logout];
}

/**
 断开连接
 */
-(void)disConnectIm{
    [[VwtIMLib sharedInstance]disConnectIm];
}


/**
 单聊消息
 
 @param text 上传接口返回的的字符串或者文本消息内容
 @param targetid     目标会话 ID
 @param requestid    UUID
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 */
-(NSString *)sendMessage:(NSString *) text
                TargetId:(NSString *) targetid
             MessageType:(VwtMessageType)messageType
    andWithExtendedField:(NSString *)extendedField
                 success:(void (^)(id value))successBlock
                   error:(void (^)(VwtError* error))errorBlock{
    return   [[VwtIMLib sharedInstance]sendMessage:text
                                          TargetId:targetid
                                         RequestId:[self getUdid]
                                       MessageType:messageType
                              andWithExtendedField:extendedField
                                           success:successBlock
                                             error:errorBlock];
}

/**
 群发消息
 
 @param msgContent   上传接口返回的的字符串或者文本消息内容
 @param targetidArr  目标会话 ID 数组
 @param requestid    UUID
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 @param messageType 消息类型
 */
-(NSString *) sendBatchMessage:(NSString *) msgContent
                      TargetId:(NSArray *) targetidArr
                   MessageType:(VwtMessageType)messageType
          andWithExtendedField:(NSString *)extendedField
                       success:(void (^)(id value))successBlock
                         error:(void (^)(VwtError* error))errorBlock{
    return   [[VwtIMLib sharedInstance]sendBatchMessage:msgContent
                                               TargetId:targetidArr
                                              RequestId:[self getUdid]
                                            MessageType:messageType
                                   andWithExtendedField:extendedField
                                                success:successBlock
                                                  error:errorBlock];
    
}

/**
 群聊消息
 
 @param msgContent   上传接口返回的的字符串或者文本消息内容
 @param targetid     目标会话 ID
 @param requestid    UUID
 @param extendedField 扩展字段
 @param successBlock 成功
 @param errorBlock   失败
 */
-(NSString *) sendMessageToGroup:(NSString *) msgContent
                        TargetId:(NSString *) targetid
                     MessageType:(VwtMessageType)messageType
            andWithExtendedField:(NSString *)extendedField
                         success:(void (^)(id value))successBlock
                           error:(void (^)(VwtError* error))errorBlock{
    return [[VwtIMLib sharedInstance]sendMessageToGroup:msgContent
                                               TargetId:targetid
                                              RequestId:[self getUdid]
                                            MessageType:messageType
                                   andWithExtendedField:extendedField
                                                success:successBlock
                                                  error:errorBlock];
}

/**
 上传文件
 
 @param FilePath 文件路径
 @param uploadLargeFileBlock 成功或者失败的块
 @param progess 上传进度
 @param timeout 超时时间
 */
-(void)uploadAttachment:(NSString*)FilePath
             andTimeout:(NSInteger)timeout
   uploadLargeFileBlock:(uploadLargeFileBlock)uploadLargeFileBlock
                progess:(void(^)(float progess))progess{
    [[VwtIMLib sharedInstance]uploadAttachment:FilePath
                                    andTimeout:timeout
                          uploadLargeFileBlock:uploadLargeFileBlock
                                       progess:progess];
}

/**
 请求开始获取离线消息
 
 @param successBlock 返回success表示请求成功
 @param errorBlock  返回错误信息
 */
-(void) getOfflineMessage:(void (^)(NSString *value))successBlock  error:(void (^)(VwtError* error))errorBlock{
    [[VwtIMLib sharedInstance]getOfflineMessage:successBlock error:errorBlock];
}

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
 @param requestId    UUID
 */
-(void) qryHisMessage:(NSString*)userId
         andStartTime:(NSString*)sTime
           andEndTime:(NSString*)eTime
             andIndex:(NSString*)index
           andPageNum:(NSString*)pageNum
           andIsGroup:(BOOL)isGroup
              success:(void (^)(VwtResponse *value))successBlock
                error:(void(^)(VwtError* error))errorBlock{
    [[VwtIMLib sharedInstance]qryHisMessage:userId
                               andStartTime:sTime
                                 andEndTime:eTime
                                   andIndex:index
                               andRequestId:[self getUdid]
                                 andPageNum:pageNum
                                 andIsGroup:isGroup
                                    success:successBlock
                                      error:errorBlock];
}


@end
