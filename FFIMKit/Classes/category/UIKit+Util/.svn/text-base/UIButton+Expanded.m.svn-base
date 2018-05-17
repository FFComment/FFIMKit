//
//  UIButton+Expanded.m
//  edu_anhui_util
//
//  Created by SmithLeo on 2017/6/6.
//
//

#import "UIButton+Expanded.h"

@implementation UIButton(Expanded)

-(void)adjustImageAboveText
{
    [super layoutSubviews];
    CGRect imageRect = self.imageView.frame;
    
    imageRect.size = CGSizeMake(30, 30);
    imageRect.origin.x = (self.frame.size.width - 30) * 0.5;
    imageRect.origin.y = self.frame.size.height * 0.5 - 40;
    CGRect titleRect = self.titleLabel.frame;
    
    titleRect.origin.x = (self.frame.size.width - titleRect.size.width) * 0.5;
    titleRect.origin.y = self.frame.size.height * 0.5;
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

- (void)adjustImageRightText
{
    [super layoutSubviews];
    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(30, 30);
    imageRect.origin.x = (self.frame.size.width - 30) ;
    imageRect.origin.y = (self.frame.size.height - 30)/2.0f;
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = (self.frame.size.width - imageRect.size.width- titleRect.size.width);
    titleRect.origin.y = (self.frame.size.height - titleRect.size.height)/2.0f;
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}

@end
