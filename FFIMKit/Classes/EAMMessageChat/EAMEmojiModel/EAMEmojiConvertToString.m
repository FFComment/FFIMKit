//
//  EAMEmojiConvertToString.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMEmojiConvertToString.h"
#import "EAMChatEmojiIcons.h"
@implementation EAMEmojiConvertToString

+ (NSString *)convertToCommonEmoticons:(NSString *)text{
    //表情数量
    NSInteger emojiCount=[EAMChatEmojiIcons getEmojiPopCount];
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    
    for(NSInteger i=1; i<=emojiCount; i++) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
//        [retText replaceOccurrencesOfString:[NSString stringWithFormat:@",Face.bundle/%@.png",@(i)]
//                                 withString:[NSString stringWithFormat:@"[em_%@]",@(i)]
//                                    options:NSLiteralSearch
//                                      range:range];
        [retText replaceOccurrencesOfString:[NSString stringWithFormat:@"%@",@(i)]
                                 withString:[NSString stringWithFormat:@"[em_%@]",@(i)]
                                    options:NSLiteralSearch
                                      range:range];
        
    }
    
    return retText;
}


@end
