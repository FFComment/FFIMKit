//
//  EAMChatOtherView.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@import AssetsLibrary;

#define ChatOtherIconsView_Hight  210.0f

@protocol EAMChatOtherViewDelegate <NSObject>

-(void)imagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType;
/**  表情 */
- (void)showFaceBtn:(UIButton *)sender;
/**  相册 */
- (void)otherViewSelectPhotoAlbum;
/**  相机 */
- (void)otherViewSelectCamera;

@end

@interface EAMChatOtherView : UIView

@property (nonatomic,assign) id<EAMChatOtherViewDelegate>delegate;

@end
