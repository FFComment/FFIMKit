//
//  EAMChatKeyBoardAnimationView.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMChatKeyBoardAnimationView.h"


@implementation EAMChatKeyBoardAnimationView

-(void)addSubview:(UIView *)view{
    
    CGRect frameS = self.frame;
    frameS.size.height = CGRectGetHeight(view.frame);
    self.frame = frameS;
    
    for (UIView * v in self.subviews) {
        [v removeFromSuperview];
    }
    
    [super addSubview:view];
    
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetHeight(self.frame);
    view.frame = frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:DURTAION animations:^{
        view.frame = frame;
    }];
}

@end
