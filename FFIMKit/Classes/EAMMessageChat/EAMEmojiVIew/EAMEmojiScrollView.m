//
//  EAMEmojiScrollView.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMEmojiScrollView.h"

@implementation EAMEmojiScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

@end
