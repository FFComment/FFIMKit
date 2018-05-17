//
//  EAMMessageListTableViewCell.h
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2017/7/10.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSString* const kIconUrl = @"";
static const NSString* const kTitle = @"title";
static const NSString* const kDesc = @"desc";

@interface EAMMessageListTableViewCell : UITableViewCell
-(void)setItem:(NSDictionary*)item;
@end
