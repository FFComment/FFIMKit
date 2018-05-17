//
//  EAMChatEmojiView.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ChatEmojiViewIconType){
    ChatEmojiViewIconTypeCommon = 0,//经典表情
    ChatEmojiViewIconTypeOther //******************自定义表情:后期版本拓展**********
};

@class EAMEmojiObj;

@protocol EAMChatEmojiViewDelegate <NSObject>

@required
- (void)chatEmojiViewSelectEmojiIcon:(EAMEmojiObj*)objIcon;//选择了某个表情
- (void)chatEmojiViewTouchUpinsideDeleteButton;//点击了删除表情

@optional
- (void)chatEmojiViewTouchUpinsideSendButton;//点击了发送表情

@end


@interface EAMChatEmojiView : UIView

@property (nonatomic,assign) id<EAMChatEmojiViewDelegate>delegate;

@end
