//
//  ICChatMessageBaseCell.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/3/12.
//  Copyright © 2016年 gxz All rights reserved.
//

#import "ICChatMessageBaseCell.h"
#import "ICMessageModel.h"
#import "ICMessage.h"
#import "ICMessageTopView.h"
#import "XZConstants.h"
#import "FF_BoundlePath.h"

@interface ICChatMessageBaseCell ()


@end

@implementation ICChatMessageBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
}

#pragma mark - Getter and Setter

- (ICHeadImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[ICHeadImageView alloc] init];
        [_headImageView setColor:IColor(219, 220, 220) bording:0.0];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIImageView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        NSString *button_retry_comment = [FF_BoundlePath ff_imagePathWithName:@"button_retry_comment" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [_retryButton setImage:[UIImage imageWithContentsOfFile:button_retry_comment] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method

- (void)retryButtonClick:(UIButton *)btn {
    if ([self.longPressDelegate respondsToSelector:@selector(reSendMessage:)]) {
        [self.longPressDelegate reSendMessage:self];
    }
}

- (void)setModelFrame:(ICMessageFrame *)modelFrame
{
    _modelFrame = modelFrame;
    
     ICMessageModel *messageModel = modelFrame.model;
    self.headImageView.frame     = modelFrame.headImageViewF;
    self.bubbleView.frame        = modelFrame.bubbleViewF;
    if (messageModel.isSender) {    // 发送者
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        switch (modelFrame.model.message.deliveryState) { // 发送状态
            case ICMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ICMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case ICMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        if ([modelFrame.model.message.type isEqualToString:TypeFile] ||[modelFrame.model.message.type isEqualToString:TypePicText]) {
            NSString *liaotianfile = [FF_BoundlePath ff_imagePathWithName:@"liaotianfile" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
            self.bubbleView.image = [UIImage imageWithContentsOfFile:liaotianfile];
        } else {
            NSString *liaotianbeijing_R = [FF_BoundlePath ff_imagePathWithName:@"liaotianbeijing_R" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
            self.bubbleView.image = [UIImage imageWithContentsOfFile:liaotianbeijing_R];
            self.bubbleView.image = [self imageStrecthing:self.bubbleView.image];
        }
        NSString *groupHead = [FF_BoundlePath ff_imagePathWithName:@"groupHead" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [self.headImageView.imageView setImage:[UIImage imageWithContentsOfFile:groupHead]];
    } else {    // 接收者
        self.retryButton.hidden  = YES;
        NSString *liaotianbeijing_L = [FF_BoundlePath ff_imagePathWithName:@"liaotianbeijing_L" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        self.bubbleView.image    = [UIImage imageWithContentsOfFile:liaotianbeijing_L];
        self.bubbleView.image = [self imageStrecthing:self.bubbleView.image];
        self.bubbleView.frame        = modelFrame.bubbleViewF;
        NSString *groupHead = [FF_BoundlePath ff_imagePathWithName:@"groupHead" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [self.headImageView.imageView setImage:[UIImage imageWithContentsOfFile:groupHead]];
    }
}
/**  拉伸图片 */
- (UIImage *)imageStrecthing:(UIImage *)image {
    CGFloat height = image.size.height / 2.0;
    CGFloat width = image.size.width / 2.0;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(width,height,width,height);
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    return newImage;
}
- (void)headClicked
{
    if ([self.longPressDelegate respondsToSelector:@selector(headImageClicked:)]) {
        [self.longPressDelegate headImageClicked:_modelFrame.model.message.from];
    }
}

#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if ([self.longPressDelegate respondsToSelector:@selector(longPress:)]) {
        [self.longPressDelegate longPress:recognizer];
    }
}




@end
