//
//  EAMChatOtherView.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMChatOtherView.h"
#import "PublicDefine.h"
#import "FF_BoundlePath.h"

#define Bt_W 50.0f
#define Bt_H 75.0f
#define Bt_s 15.0f


@interface ButtonIcon : UIButton

@end

@implementation ButtonIcon

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTitleColor:kAppMainDarkGrayColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    contentRect = CGRectMake(0, 0, Bt_W, Bt_W);
    return contentRect;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    contentRect = CGRectMake(0, Bt_W+5.0f, Bt_W, Bt_H-Bt_W);
    return contentRect;
}

@end


@interface EAMChatOtherView()
{
    ButtonIcon * _Album;//图片
    ButtonIcon * _Camera;//拍照
    ButtonIcon * _face; //表情
}
@end

@implementation EAMChatOtherView

-(instancetype)init{
    
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, kScreenWidth, ChatOtherIconsView_Hight);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kAppMainBgColor;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _face = [[ButtonIcon alloc]initWithFrame:CGRectMake(Bt_s, Bt_s, Bt_W, Bt_H)];
    NSString *facePath = [FF_BoundlePath ff_imagePathWithName:@"more_face" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
    [_face setImage:[UIImage imageWithContentsOfFile:facePath] forState:UIControlStateNormal];
    [_face setTitle:@"表情" forState:UIControlStateNormal];
    [_face addTarget:self action:@selector(selectFace) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_face];
    
    
    _Album = [[ButtonIcon alloc]initWithFrame:CGRectMake(Bt_W+Bt_s*3, Bt_s, Bt_W, Bt_H)];
    NSString *albumPath = [FF_BoundlePath ff_imagePathWithName:@"more_pic" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
    [_Album setImage:[UIImage imageWithContentsOfFile:albumPath] forState:UIControlStateNormal];
    [_Album setTitle:@"相册" forState:UIControlStateNormal];
    [_Album addTarget:self action:@selector(selectPhotoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_Album];
    
    _Camera = [[ButtonIcon alloc]initWithFrame:CGRectMake(Bt_W*2+Bt_s*5, Bt_s, Bt_W, Bt_H)];
    NSString *cameraPath = [FF_BoundlePath ff_imagePathWithName:@"more_camera" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
    [_Camera setImage:[UIImage imageWithContentsOfFile:cameraPath] forState:UIControlStateNormal];
    [_Camera setTitle:@"拍照" forState:UIControlStateNormal];
    [_Camera addTarget:self action:@selector(selectCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_Camera];
    
}

#pragma mark - 相机,相册-处理
- (void)selectFace { //表情
    if ([self.delegate respondsToSelector:@selector(showFaceBtn:)]) {
        [self.delegate showFaceBtn:_face];
    }
}
-(void)selectPhotoAlbum{//相册
    if ([self.delegate respondsToSelector:@selector(otherViewSelectPhotoAlbum)]) {
        [self.delegate otherViewSelectPhotoAlbum];
    }
}
-(void)selectCamera{//相机
    if ([self.delegate respondsToSelector:@selector(otherViewSelectCamera)]) {
        [self.delegate otherViewSelectCamera];
    }
}
-(void)sourceType:(UIImagePickerControllerSourceType)type{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerSourceType:)]) {
        [self.delegate imagePickerControllerSourceType:type];
    }
}

@end
