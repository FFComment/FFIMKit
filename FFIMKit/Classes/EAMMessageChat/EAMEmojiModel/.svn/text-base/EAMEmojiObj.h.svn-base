//
//  EAMEmojiObj.h
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define  EmojiIMG_Width_Hight   32.0f  //表情图片宽高
#define  EmojiView_Border       12.0f  //边框
#define  EmojiIMG_Space         24.0f  //表情间距
#define  EmojiIMG_Space_UP      13.0f  //表情上下间距
#define  EmojiIMG_Lines         3      //表情行数

@interface EAMEmojiObj : NSObject


@property (nonatomic,copy) NSString * emojiName; //表情名称
@property (nonatomic,copy) NSString * emojiImgName; //表情图片名称
@property (nonatomic,copy) NSString * emojiString; //表情码文

+(NSInteger)countInOneLine; //一行多少图片
+(NSInteger)onePageCount;
+(NSInteger)pageCountIsSupport; //支持几页
+(NSArray*)emojiObjsWithPage:(NSInteger)page;
+(EAMEmojiObj*)del_Obj;

@end
