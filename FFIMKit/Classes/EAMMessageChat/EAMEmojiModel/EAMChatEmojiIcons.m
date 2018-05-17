//
//  EAMChatEmojiIcons.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMChatEmojiIcons.h"
#import "FF_BoundlePath.h"
@implementation EAMChatEmojiIcons

//获取表情包
+ (NSArray *)emojis {
    static NSArray *_emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取表情plist
        NSString *path = [FF_BoundlePath ff_imagePathWithName:@"EmotionImage" bundle:@"FFIMKit" targetClass:[self class] oftype:@"plist"];
//        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EmotionImage.plist"];
        NSDictionary *emojiDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSMutableArray *array=[NSMutableArray array];
        for (NSInteger i=1; i<58; i++) {
            [array addObject:[emojiDic valueForKey:[NSString stringWithFormat:@"[em_%@]",@(i)]]];
        }
        _emojis = array;
    });
    return _emojis;
}

+(NSInteger)getEmojiPopCount{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag {
    NSArray *emojis = [[self class] emojis];
    return emojis[tag];
}

+(NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag{
    NSString * name = [[self class]getEmojiNameByTag:tag];
    return [[self class]imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag {
    NSString *key = [NSString stringWithFormat:@"%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+(NSString *)imgNameWithName:(NSString*)name{
    return [NSString stringWithFormat:@"%@",name];
}


@end