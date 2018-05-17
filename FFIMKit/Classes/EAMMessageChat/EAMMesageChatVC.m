//
//  EAMMesageChatVC.m
//  edu_anhui_messageKit
//
//  Created by yangjuanping on 2018/3/13.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMMesageChatVC.h"
#import "YYTextView.h"
#import "EAMChatKeyBoardView.h"
#import "UIView+Category.h"
#import "EAMVoiceRecordHelper.h"
#import "EAMVoiceRecordHUD.h"
#import "PublicDefine.h"
#import "LocalImageHelper.h"

#define duration 0.25f
@interface EAMMesageChatVC () <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EAMChatKeyBoardViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) EAMChatKeyBoardView *chatKeyBoardView;
@property (nonatomic, strong, readwrite) EAMVoiceRecordHUD *voiceRecordHUD; //录音提示
@property (nonatomic, strong) EAMVoiceRecordHelper *voiceRecordHelper; //录音管理工具
@property (nonatomic) BOOL isMaxTimeStop; //判断是不是超出了录音最大时长


@end

@implementation EAMMesageChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    
    //聊天键盘置于tableView之上
    [self.view insertSubview:self.tableView belowSubview:self.chatKeyBoardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePressBtnChange) name:@"voicePressBtnChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputHChange:) name:@"textInputFrameChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --
#pragma mark -- UIScrollerDelegate
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections]; //有多少组
    if (s<1) return; //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1]; //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //  退出键盘
    [self.chatKeyBoardView endEditing:YES];
//    [self.chatKeyBoardView tapAction];
//    self.tableView.frame=[self tableViewFrame];
    [UIView animateWithDuration:duration animations:^{
        [self.chatKeyBoardView tapAction];
        self.tableView.frame=[self tableViewFrame];
    }];
}
#pragma mark - 发送音频代理
// 准备开始录音
- (void)prepareRecordingVoiceActionWithCompletion:(BOOL (^)(void))completion {
    [self.voiceRecordHelper prepareRecordingWithPath:[self getRecorderPath] prepareRecorderCompletion:completion];
}
// 开始录音
- (void)didStartRecordingVoiceAction {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithStartRecorderCompletion:^{
    }];
}
// 取消录音
- (void)didCancelRecordingVoiceAction {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    }];
}
// 完成录音
- (void)didFinishRecoingVoiceAction {
    if (self.isMaxTimeStop == NO) {
        [self finishRecorded];
    } else {
        self.isMaxTimeStop = NO;
    }
}
- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        weakSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    }];
}
// 移出录音区间
- (void)didDragOutsideAction {
    [self.voiceRecordHUD resaueRecord];
}
// 移入录音区间
- (void)didDragInsideAction {
    [self.voiceRecordHUD pauseRecord];
}
// 录音文件地址
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    recorderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    recorderPath = [recorderPath stringByAppendingFormat:@"MySound.m4a"];
    return recorderPath;
}
// 相册
- (void)chatViewSelectPhotoAlbum {
    [LocalImageHelper selectPhotoFromLibray:self];
}
// 相机
- (void)chatViewSelectCamera {
    [LocalImageHelper selectPhotoFromCamera:self];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (!cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click -- section:%ld, row:%ld", indexPath.section, indexPath.row);
}
#pragma mark -- NSNotificationCenter
- (void)keyboardWillShow:(NSNotification *)info
{
    NSDictionary *userInfo = info.userInfo;
//    //获取键盘弹出的动画时间
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey ] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.tableView.frame=[self tableViewFrame];
    }];
    [self scrollTableToFoot:YES];
}
//键盘变动,更新frame
- (void)inputHChange:(NSNotification *)info {
    CGFloat offset = [[info.userInfo valueForKey:@"offset"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.view.current_w, self.view.current_h -offset);
    }];
    [self scrollTableToFoot:YES];
}
- (void)voicePressBtnChange {
    [UIView animateWithDuration:duration animations:^{
        self.tableView.frame=[self tableViewFrame];
    }];
}
#pragma mark - 懒加载
//聊天框
- (EAMChatKeyBoardView *)chatKeyBoardView{
    if (!_chatKeyBoardView) {
        _chatKeyBoardView=[[EAMChatKeyBoardView alloc]initWithDelegate:self superView:self.view];
        _chatKeyBoardView.delegate = self;
    }
    return _chatKeyBoardView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:[self tableViewFrame] style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

//tableView的frame随着聊天框的frame变化:如弹出键盘时
-(CGRect)tableViewFrame{
    CGRect frame = CGRectMake(0, 0, self.view.current_w, self.view.current_h);
    frame.size.height = self.chatKeyBoardView.frame.origin.y;
    return frame;
}
//录音HUD
- (EAMVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[EAMVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}
//录音
- (EAMVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        _isMaxTimeStop = NO;
        
        WEAKSELF
        _voiceRecordHelper = [[EAMVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            NSLog(@"已经达到最大限制时间了，进入下一步的提示");
            weakSelf.isMaxTimeStop = YES;
            [weakSelf finishRecorded]; //超时 直接发送
        };
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            weakSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = 60.0;
    }
    return _voiceRecordHelper;
}
@end
