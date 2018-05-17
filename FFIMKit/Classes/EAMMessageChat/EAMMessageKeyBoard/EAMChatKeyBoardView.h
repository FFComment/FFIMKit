//
//  EAMChatKeyBoardView.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAMChatInputTextView.h"

@class EAMChatKeyBoardView;

@protocol EAMChatKeyBoardViewDelegate <NSObject>

//发送文字
//- (void)returnBtnClickedWithText:(NSString *)text;
//准备录音
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion;
//开始录音
- (void)didStartRecordingVoiceAction;
//手指向上滑动取消录音
- (void)didCancelRecordingVoiceAction;
//松开手指完成录音
- (void)didFinishRecoingVoiceAction;
//当手指离开按钮的范围内时，主要为了通知外部的HUD
- (void)didDragOutsideAction;
//当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
- (void)didDragInsideAction;
/**  相册 */
- (void)chatViewSelectPhotoAlbum;
/**  相机 */
-(void)chatViewSelectCamera;

@optional
//根据键盘是否弹起，设置tableView frame
-(void)keyBoardView:(EAMChatKeyBoardView *)keyBoard ChangeDuration:(CGFloat)durtaion;

//发送消息
-(void)keyBoardView:(EAMChatKeyBoardView*)keyBoard sendMessage:(NSString*)message;

//相册、拍照
-(void)keyBoardView:(EAMChatKeyBoardView*)keyBoard imgPicType:(UIImagePickerControllerSourceType)sourceType;


@end


@interface EAMChatKeyBoardView : UIView
@property (assign, nonatomic) CGFloat keyboardHeight;
@property (assign, nonatomic) CGFloat inputH;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL isClickPlus;
@property (assign, nonatomic) BOOL isCancleRecord;
@property (assign, nonatomic) BOOL isRecording;
@property (nonatomic,strong) UIView *chatBgView;//聊天框
@property (nonatomic,strong) EAMChatInputTextView *chatInputTextView;//聊天输入
@property (nonatomic,assign) id<EAMChatKeyBoardViewDelegate>delegate;

//初始化init
- (instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView;

//动态调整textView的高度
-(void)textViewChangeText;

//
-(void)tapAction;

@end
