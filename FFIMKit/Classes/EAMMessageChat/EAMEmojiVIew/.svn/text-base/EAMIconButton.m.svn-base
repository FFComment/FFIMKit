//
//  EAMIconButton.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMIconButton.h"

#define IMG_H_W  20.0f
#define UICOLOR_FROM_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation EAMIconButton

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        UIView * line = [[UIView alloc]initWithFrame:
                         CGRectMake(self.bounds.size.width-0.5, 0, 0.5, self.bounds.size.height)];
        line.backgroundColor = UICOLOR_FROM_RGB(149, 165, 166, 1);
        [self addSubview:line];
    }
    
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect rect = [super imageRectForContentRect:contentRect];
    rect.size.height = rect.size.width = IMG_H_W;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    rect.origin = CGPointMake((w-IMG_H_W)/2.0f, (h-IMG_H_W)/2.0f);
    
    return rect;
}
@end
