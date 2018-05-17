//
//  UIButton+Countdown.h
//  edu_anhui_util
//
//  Created by yangjuanping on 2017/6/20.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (Countdown)
#pragma mark -倒计时
/*
 *  timeout:开始时间         eg. 60
 *  forward:前半句提示语      eg. @"还剩"
 *  backward:后半句提示语     eg. @"秒"
 */

- (void)countDownWithStartTime:(NSInteger)timeout
              waitTitleForward:(NSString *)forward
                      backward:(NSString *)backward;

/*
 *  progress:倒计时回调   lastTime:剩余时间
 *  completion:结束回调
 */
- (void)countDownWithStartTime:(NSInteger)timeout
                      progress:(void(^)(NSInteger lastTime))progress
                    completion:(void(^)())completion;


#pragma mark -点击事件
@property (nonatomic,copy) void (^click)();
@end
