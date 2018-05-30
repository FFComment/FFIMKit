//
//  EAMMesageChatVC.h
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2018/3/13.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZGroup.h"

@protocol EAMMesageChatVCDelegate <NSObject>

/**  发送消息 */
- (void)chatVCSendMessage:(NSString *)message;

@end
@interface EAMMesageChatVC : UIViewController

@property (nonatomic, strong) XZGroup *group;
@property (nonatomic, weak) id<EAMMesageChatVCDelegate> delegate;

@end
