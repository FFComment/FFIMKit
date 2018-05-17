//
//  EAMEmojiButton.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMEmojiButton.h"
#import "EAMEmojiObj.h"
#import "FF_BoundlePath.h"
@implementation EAMEmojiButton

-(void)setEmojiIcon:(EAMEmojiObj *)emojiIcon{
    _emojiIcon = emojiIcon;

    NSArray *array = [emojiIcon.emojiImgName componentsSeparatedByString:@"."];
    NSString *path = [FF_BoundlePath ff_imagePathWithName:[NSString stringWithFormat:@"%@",array[0]] bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
    [self setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
}

@end
