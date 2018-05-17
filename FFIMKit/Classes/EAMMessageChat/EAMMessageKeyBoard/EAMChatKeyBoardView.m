//
//  EAMChatKeyBoardView.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMChatKeyBoardView.h"
#import "EAMChatKeyBoardAnimationView.h"//聊天框底部contain
#import "EAMChatEmojiView.h"//表情键盘View
#import "EAMChatOtherView.h"//照片和拍照
#import "EAMEmojiObj.h"
#import "EAMEmojiTextAttachment.h"
#import "PublicDefine.h"
#import "UIView+Category.h"
#import "UIImage+Category.h"
#import "UIView+ViewController.h"
#import "FF_BoundlePath.h"

@interface EAMChatKeyBoardView()
<EAMChatEmojiViewDelegate,EAMChatOtherViewDelegate,UITextViewDelegate>
{
    NSArray *_icons;//表情、添加按钮集
    CGFloat hight_text_one;
    
    BOOL keyBoardTap;
    EAMChatEmojiView *_emojiView;//表情键盘
    EAMChatOtherView *_otherView;//照片和拍照View
    
}
@property (nonatomic,strong) EAMChatKeyBoardAnimationView *bottomView;

@property (nonatomic,strong)  UIButton *audioBtn;//语音按钮
@property (nonatomic,strong)  UIButton *otherBtn;//其他按钮(图片、拍照)
@property (nonatomic, strong) UIButton *voicePressBtn;//录制语音按钮
@property (nonatomic,strong)  UIButton *sendBtn;//发送按钮
@end

@implementation EAMChatKeyBoardView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化 init
- (instancetype)initWithDelegate:(id)delegate superView:(UIView *)superView{
    self=[super init];
    if (self) {
        //布局View
        self.inputH = 49.5;
        [self setUpView];
        [self addNotifations];
        [self addToSuperView:superView];
        self.delegate=delegate;
    }
    return self;
}

#pragma mark setUpView
- (void)setUpView{
    //聊天框及bottomView
    [self initChatBgView];
    //添加按钮
    [self addIcons];
    //表情视图和 图片，拍照
    [self initIconsContentView];
    
}
- (void)initChatBgView{
    //聊天框
    [self addSubview:self.chatBgView];
    [self addSubview:self.bottomView];
}

-(void)initIconsContentView{
    _emojiView = [[EAMChatEmojiView alloc]init];
    _emojiView.delegate = self;
    
    _otherView = [[EAMChatOtherView alloc]init];
    _otherView.delegate = self;
}

#pragma mark - 录音按钮各种点击状态
- (void)holdDownButtonTouchDown {
    self.isCancleRecord = NO;
    self.isRecording = NO;
    //    SHOW(@"按下");
    BOOL t = [self.delegate respondsToSelector:@selector(prepareRecordingVoiceActionWithCompletion:)];
    if (t) {
        WEAKSELF
        //這邊回調 return 的 YES, 或 NO, 可以讓底層知道該次錄音是否成功, 進而處理無用的 record 對象
        [self.delegate prepareRecordingVoiceActionWithCompletion:^BOOL{
            STRONGSELF
            //這邊要判斷回調回來的時候, 使用者是不是已經早就鬆開手了
            if (strongSelf && !strongSelf.isCancleRecord) {
                strongSelf.isRecording = YES;
                [strongSelf.delegate didStartRecordingVoiceAction];
                return YES;
            } else {
                NSLog(@"说话时间太短");
                return NO;
            }
        }];
    }
}

- (void)holdDownButtonTouchUpOutside {
    //如果已經開始錄音了, 才需要做取消的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
            [self.delegate didCancelRecordingVoiceAction];
        }
    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownButtonTouchUpInside {
    //如果已經開始錄音了, 才需要做結束的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
            [self.delegate didFinishRecoingVoiceAction];
        }
    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownDragOutside {
    //如果已經開始錄音了, 才需要做拖曳出去的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
            [self.delegate didDragOutsideAction];
        }
    } else {
        self.isCancleRecord = YES;
    }
}

- (void)holdDownDragInside {
    //如果已經開始錄音了, 才需要做拖曳回來的動作, 否則只要切換 isCancelled, 不讓錄音開始.
    if (self.isRecording) {
        if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
            [self.delegate didDragInsideAction];
        }
    } else {
        self.isCancleRecord = YES;
    }
}
#pragma mark textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
//        [self sendMessage];
        [self sendBtnClicked];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [self textViewChangeText];
}

//-(void)sendMessage{
//    if (![self.chatInputTextView hasText]&&(self.chatInputTextView.text.length==0)) {
//        return;
//    }
//    NSString *plainText = self.chatInputTextView.plainText;
//    //空格处理
//    plainText = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//    if (plainText.length > 0) {
//        [self sendMessage:plainText];
//        self.chatInputTextView.text = @"";
//        [self textViewChangeText];
//    }
//}

#pragma mark 添加通知
- (void)addNotifations{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow)name:UIKeyboardDidShowNotification object:nil];
}
#pragma mark - 系统键盘通知事件
-(void)keyBoardHiden:(NSNotification*)noti{
    //隐藏键盘
    self.isEditing = NO;
    if (keyBoardTap==NO) {
        CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        CGFloat duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect fram = self.frame;
        fram.origin.y = (endF.origin.y - self.chatBgView.frame.size.height);
        [self duration:duration EndF:fram];
    }else{
        keyBoardTap = NO;
    }
}
-(void)keyBoardShow:(NSNotification*)noti{
    //显示键盘
    self.isEditing = YES;
    CGRect endF = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (keyBoardTap==NO) {
        for (UIButton * b in _icons) {
            b.selected = NO;
        }
        [self.bottomView addSubview:[UIView new]];
        
        NSTimeInterval duration = [[noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect fram = self.frame;
        fram.origin.y = (endF.origin.y - _chatBgView.frame.size.height);
        [self duration:duration EndF:fram];
    }else{
        keyBoardTap = NO;
    }
}
- (void)keyboardDidShow {
    self.isEditing = YES;
    self.isClickPlus = NO;
}
-(void)duration:(CGFloat)duration EndF:(CGRect)endF{
    [UIView animateWithDuration:duration animations:^{
        keyBoardTap = NO;
        self.frame = endF;
    }];
    [self changeDuration:duration];
}

#pragma mark - self delegate action
-(void)changeDuration:(CGFloat)duration{
    //动态调整tableView高度
    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:ChangeDuration:)]) {
        [self.delegate keyBoardView:self ChangeDuration:duration];
    }
}
- (void)sendMessage:(NSString *)message{
    //发送消息
    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:sendMessage:)]) {
        [_delegate keyBoardView:self sendMessage:message];
    }
}
-(void)imagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType{
    //相册  拍照
    if (_delegate&&[self.delegate respondsToSelector:@selector(keyBoardView:imgPicType:)]) {
        [self.delegate keyBoardView:self imgPicType:sourceType];
    }
}

#pragma mark addToSuperView
- (void)addToSuperView:(UIView *)superView{
    CGFloat s_h = CGRectGetHeight(superView.bounds);
    CGRect frame = CGRectMake(0,s_h-kTabBarHeight-0.5,kScreenWidth, s_h+0.5);
    self.frame = frame;
    [superView addSubview:self];
}

#pragma mark Event
- (void)iconsAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            //语音
//            sender.selected = !sender.selected;
            //  遍历按钮的状态
            for (UIButton * b in _icons) {
                if ([b isEqual:sender]) sender.selected = !sender.selected;
                else b.selected = NO;
            }
            if (sender.selected) { // 语音状态
                self.voicePressBtn.hidden = NO;
                [self.chatInputTextView resignFirstResponder];
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = CGRectMake(0, kScreenHeight - self.inputH, kScreenWidth, self.inputH);
                }];
                self.voicePressBtn.frame = CGRectMake(CGRectGetMaxX(self.otherBtn.frame)+3, 5, kScreenWidth-150, hight_text_one+20);

            }else{ // 文字状态
                self.voicePressBtn.hidden = YES;
                [self.chatInputTextView becomeFirstResponder];
                self.frame = CGRectMake(0, kScreenHeight-keyboardHeight-self.inputH, kScreenWidth, keyboardHeight+self.inputH);
                self.voicePressBtn.frame = CGRectMake(CGRectGetMaxX(self.otherBtn.frame)+3, 5, kScreenWidth-150, hight_text_one+20);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"voicePressBtnChange" object:nil];
        }
            break;
        case 2:{ // 图片表情
            [self visiableView:_otherView btn:sender];
            self.isClickPlus = YES;
            NSString *offset = [NSString stringWithFormat:@"%f",ChatEmojiView_Hight + self.inputH];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"textInputFrameChange" object:nil userInfo:@{@"offset":offset}];
        }
            break;
        default:{
            [self visiableView:[[UIView alloc]init] btn:nil];
        }
            break;
    }
}
#pragma mark -- EAMChatOtherViewDelegate
- (void)showFaceBtn:(UIButton *)sender {
    [self visiableView:_emojiView btn:sender];
}
-(void)otherViewSelectPhotoAlbum{//相册
    if ([self.delegate respondsToSelector:@selector(chatViewSelectPhotoAlbum)]) {
        [self.delegate chatViewSelectPhotoAlbum];
    }
}
-(void)otherViewSelectCamera{//相机
    if ([self.delegate respondsToSelector:@selector(chatViewSelectCamera)]) {
        [self.delegate chatViewSelectCamera];
    }
}
- (void)visiableView:(UIView *)visiableView  btn:(UIButton *)sender {
    if (sender.selected) {
        [self.chatInputTextView becomeFirstResponder];
        return;
    }else{
        keyBoardTap = YES;
        [self.chatInputTextView resignFirstResponder];
        if (sender != nil) {
            self.voicePressBtn.hidden = YES;
            self.frame = CGRectMake(0, kScreenHeight-keyboardHeight-self.inputH, kScreenWidth, keyboardHeight+self.inputH);
        }
    }
    for (UIButton * b in _icons) {
        if ([b isEqual:sender]) sender.selected = !sender.selected;
        else b.selected = NO;
    }
    //  添加到底部视图
    [self.bottomView addSubview:visiableView];
    CGRect fram = self.frame;
    fram.origin.y =kScreenHeight- (CGRectGetHeight(visiableView.frame) + self.chatBgView.bounds.size.height);
    [self duration:DURTAION EndF:fram];
}
#pragma mark - self public api action
-(void)tapAction{
    UIButton * b = [[UIButton alloc]init];
    b.selected = NO;
    [self iconsAction:b];
}
// 动态调整textView的高度
-(void)textViewChangeText{
    CGFloat h = [self.chatInputTextView.layoutManager usedRectForTextContainer:self.chatInputTextView.textContainer].size.height;
    self.chatInputTextView.contentSize = CGSizeMake(self.chatInputTextView.contentSize.width, h+20);
    CGFloat five_h = hight_text_one*5.0f;
    h = h>five_h?five_h:h;
    CGRect frame = self.chatInputTextView.frame;
    CGFloat diff = self.chatBgView.frame.size.height - self.chatInputTextView.frame.size.height;
    if (frame.size.height == h+20) {
        if (h == five_h) {
            [self.chatInputTextView setContentOffset:CGPointMake(0, self.chatInputTextView.contentSize.height - h - 20) animated:NO];
        }
        return;
    }
    
    frame.size.height = h+20;
    self.chatInputTextView.frame = frame;
    [self topLayoutSubViewWithH:(frame.size.height+diff)];
    [self.chatInputTextView setContentOffset:CGPointZero animated:YES];
}

-(void)topLayoutSubViewWithH:(CGFloat)hight{
    CGRect frame = self.chatBgView.frame;
    CGFloat diff = hight - frame.size.height;
    frame.size.height = hight;
    self.chatBgView.frame = frame;
    
    frame = self.bottomView.frame;
    frame.origin.y = CGRectGetHeight(self.chatBgView.bounds);
    self.bottomView.frame = frame;
    
    frame = self.frame;
    frame.origin.y -= diff;
    
    [self duration:DURTAION EndF:frame];
}

#pragma mark 发送消息按钮
- (void)sendBtnClicked{
    //发送
    if (![self.chatInputTextView hasText]&&(self.chatInputTextView.text.length==0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发送内容不能为空" message:NULL preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:sureAction];
        [[self viewController] presentViewController:alertController animated:YES completion:^{
            //隔一会就消失
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[weakSelf viewController] dismissViewControllerAnimated:YES completion:^{

                }];
            });
        }];
    }
    NSString *plainText = self.chatInputTextView.plainText;
    //空格处理
    plainText = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (plainText.length > 0) {
        [self sendMessage:plainText];
        self.chatInputTextView.text = @"";
        [self textViewChangeText];
    }
    
}

#pragma mark - chat Emoji View Delegate
- (void)chatEmojiViewSelectEmojiIcon:(EAMEmojiObj *)objIcon{
    //选择了某个表情
    EAMEmojiTextAttachment *attach = [[EAMEmojiTextAttachment alloc] initWithData:nil ofType:nil];
    attach.Top = -3.5;
    NSArray *array = [objIcon.emojiImgName componentsSeparatedByString:@"."];
    NSString *path = [FF_BoundlePath ff_imagePathWithName:[NSString stringWithFormat:@"%@",array[0]] bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];    attach.image = [UIImage imageWithContentsOfFile:path];
    NSMutableAttributedString * attributeString =[[NSMutableAttributedString alloc]initWithAttributedString:self.chatInputTextView.attributedText];;
    if (attach.image && attach.image.size.width > 1.0f) {
        attach.emoName = objIcon.emojiString;
        [attributeString insertAttributedString:[NSAttributedString attributedStringWithAttachment:attach] atIndex:_chatInputTextView.selectedRange.location];
        
        NSRange range;
        range.location = self.chatInputTextView.selectedRange.location;
        range.length = 1;
        
        NSParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle];
        
        [attributeString setAttributes:@{NSAttachmentAttributeName:attach, NSFontAttributeName:self.chatInputTextView.font,NSBaselineOffsetAttributeName:[NSNumber numberWithInt:0.0], NSParagraphStyleAttributeName:paragraph} range:range];
    }
    self.chatInputTextView.attributedText = attributeString;
    [self textViewChangeText];
}
- (void)chatEmojiViewTouchUpinsideSendButton{
    //表情键盘：点击发送表情
//    [self sendMessage];
    [self sendBtnClicked];
}
- (void)chatEmojiViewTouchUpinsideDeleteButton{
    //点击了删除表情
    NSRange range = self.chatInputTextView.selectedRange;
    NSInteger location = (NSInteger)range.location;
    if (location == 0) {
        return;
    }
    range.location = location-1;
    range.length = 1;
    
    NSMutableAttributedString *attStr = [self.chatInputTextView.attributedText mutableCopy];
    [attStr deleteCharactersInRange:range];
    self.chatInputTextView.attributedText = attStr;
    self.chatInputTextView.selectedRange = range;
    [self textViewChangeText];
}

#pragma mark - 添加表情、+按钮

//  聊天框
- (UIView *)chatBgView{
    if (!_chatBgView) {
        _chatBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabBarHeight+0.5)];
        [_chatBgView setBackgroundColor:UICOLOR_FROM_RGB(245, 245, 245, 1)];
        [_chatBgView.layer setBorderColor:kAppLightGrayColor.CGColor];
        [_chatBgView.layer setBorderWidth:0.5];
        [_chatBgView addSubview:self.chatInputTextView];
        [_chatBgView addSubview:self.sendBtn];
    }
    return _chatBgView;
}

//  聊天框底部View
- (EAMChatKeyBoardAnimationView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[EAMChatKeyBoardAnimationView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.chatBgView.frame), kScreenWidth, ChatEmojiView_Hight)];
    }
    return _bottomView;
}
//  添加键盘切换图片
- (void)addIcons{
    _icons=@[self.audioBtn,self.otherBtn];
    
    for (UIButton *btn in _icons) {
        NSString *path = [FF_BoundlePath ff_imagePathWithName:@"chat_bottom_keyboard_nor" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [btn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(iconsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chatBgView addSubview:btn];
    }
}

//  语音
- (UIButton *)audioBtn{
    if (!_audioBtn) {
        _audioBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setFrame:CGRectMake(3, 0, 35, kTabBarHeight)];
        NSString *path = [FF_BoundlePath ff_imagePathWithName:@"ic_voice" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [_audioBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        [_audioBtn setTag:1];
    }
    return _audioBtn;
}
// 添加“+”
- (UIButton *)otherBtn{
    if (!_otherBtn) {
        _otherBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_otherBtn setFrame:CGRectMake(self.audioBtn.current_x_w, 0, 40, kTabBarHeight)];
        NSString *path = [FF_BoundlePath ff_imagePathWithName:@"ic_add_blue" bundle:@"FFIMKit" targetClass:[self class] oftype:@"png"];
        [_otherBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        [_otherBtn setTag:2];
    }
    return _otherBtn;
}
//  录制语音
- (UIButton *)voicePressBtn {
    if (!_voicePressBtn) {
        _voicePressBtn = [[UIButton alloc]init];
        [_voicePressBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voicePressBtn setTitleColor:RGB(0x666666) forState:UIControlStateNormal];
        _voicePressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _voicePressBtn.layer.borderColor = RGB(0x666666).CGColor;
        _voicePressBtn.layer.borderWidth = 0.5;
        _voicePressBtn.layer.cornerRadius = 5;
        [_voicePressBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_voicePressBtn setBackgroundImage:IMAGENAMED(@"im_input_voice_normal") forState:UIControlStateNormal];
        [_voicePressBtn setBackgroundImage:IMAGENAMED(@"im_input_voice_highlited") forState:UIControlStateHighlighted];
        [self addSubview:_voicePressBtn];
        _voicePressBtn.hidden = YES;
        _voicePressBtn.backgroundColor = RGB(0xf6f6f6);
        
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_voicePressBtn addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_voicePressBtn addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
    }
    return _voicePressBtn;
}
//  聊天输入框
- (EAMChatInputTextView *)chatInputTextView{
    if (!_chatInputTextView) {
        _chatInputTextView=[[EAMChatInputTextView alloc]init];
        [_chatInputTextView setFont:UIFont_size(16.0)];
        [_chatInputTextView setBackgroundColor:kAppWhiteColor];
        [_chatInputTextView.layer setBorderWidth:0.5];
        [_chatInputTextView.layer setBorderColor:kAppLineColor.CGColor];
        [_chatInputTextView.layer setCornerRadius:kAppMainCornerRadius];
        [_chatInputTextView.layer setMasksToBounds:YES];
        [_chatInputTextView setReturnKeyType:UIReturnKeySend];
        [_chatInputTextView setEnablesReturnKeyAutomatically:YES];
        [_chatInputTextView setTextContainerInset:UIEdgeInsetsMake(10, 0, 5, 0)];
        [_chatInputTextView setDelegate:self];
        
        hight_text_one = [_chatInputTextView.layoutManager usedRectForTextContainer:_chatInputTextView.textContainer].size.height;
        
        [_chatInputTextView setFrame:CGRectMake(CGRectGetMaxX(self.otherBtn.frame)+3, 5,kScreenWidth-150, hight_text_one+20)];
        
    }
    return _chatInputTextView;
}

//  发送按钮
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setFrame:CGRectMake(self.chatInputTextView.current_x_w+8, 8, kScreenWidth-10-(self.chatInputTextView.current_x_w+3),kTabBarHeight-16)];
        [_sendBtn.layer setBorderColor:kAppMainLightBrownColor.CGColor];
        [_sendBtn.layer setBorderWidth:0.5];
        [_sendBtn setTitleColor:kAppMainLightBrownColor forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:UIFont_size(14.0)];
        [_sendBtn setBackgroundImage:[UIImage imageFormColor:kAppWhiteColor frame:_sendBtn.bounds] forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage imageFormColor:kAppLineColor frame:_sendBtn.bounds] forState:UIControlStateHighlighted];
        [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
@end
