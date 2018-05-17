//
//  EAMChatInputTextView.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAMEmojiTextAttachment.h"

@interface EAMChatInputTextView : UITextView <NSTextStorageDelegate>


@property (nonatomic, copy)NSString * plainText;

+ (CGRect)getJamTextSize:(CGSize)constrainedSize attributeString:(NSAttributedString *)attributeString;

+ (NSAttributedString *)getAttributedText:(NSString *)source font:(UIFont *)font color:(UIColor*)color jamScale:(float)jamScale bottom:(float)bottom;

@end
