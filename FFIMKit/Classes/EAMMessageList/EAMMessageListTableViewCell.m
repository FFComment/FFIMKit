//
//  EAMMessageListTableViewCell.m
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2017/7/10.
//  Copyright © 2017年 yangjuanping. All rights reserved.
//

#import "EAMMessageListTableViewCell.h"
#import <FFIMKit/FFIMKit-umbrella.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>

@interface EAMMessageListTableViewCell()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel*     titleLabel;
@property(nonatomic,strong)UILabel*     descLabel;
@end

@implementation EAMMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

-(void)setItem:(NSDictionary*)item{
    //[self.icon sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:kIconUrl]] placeholderImage:[UIImage imageNamed:@""]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"005@2x" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    _icon.image =[UIImage sd_animatedGIFWithData:gifData];
    [self.titleLabel setText:[item objectForKey:kTitle]];
    [self.descLabel setText:[item objectForKey:kDesc]];
}

#pragma mark -- setters and getters
-(UIImageView*)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}
-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+10, CGRectGetMinY(self.icon.frame), MAIN_WIDTH-CGRectGetMaxX(self.icon.frame)-10, CGRectGetHeight(self.icon.frame)/2)];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel*)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.icon.frame)-20, CGRectGetWidth(self.titleLabel.frame), 20)];
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}
@end
