//
//  EAMEmojiTextAttachment.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMEmojiTextAttachment.h"

@implementation EAMEmojiTextAttachment


- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex{
    
    return CGRectMake(0, self.Top, lineFrag.size.height*self.Scale, lineFrag.size.height*self.Scale);
}

-(instancetype)initWithData:(NSData *)contentData ofType:(NSString *)uti{
    self = [super initWithData:contentData ofType:uti];
    if (self) {
        self.Scale = 1.0f;
        self.Top = 0.0f;
        if (self.image == nil) {
            self.image = [UIImage imageWithData:contentData];
        }
    }
    return self;
}

@end
