//
//  EAMEmojiObj.m
//  edu_anhui_messageKit
//
//  Created by Sunny_zhao on 2018/5/7.
//  Copyright © 2018年 yangjuanping. All rights reserved.
//

#import "EAMEmojiObj.h"

//宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation EAMEmojiObj

/*子类中实现*/
+(NSArray *)emojiObjsWithPage:(NSInteger)page{return @[];}

+(NSInteger)pageCountIsSupport{return 0;}

/*子类不需要实现*/
+(NSInteger)countInOneLine{
    return  (kScreenWidth+EmojiIMG_Space-2*EmojiView_Border)/(EmojiIMG_Width_Hight+EmojiIMG_Space);
}

+(NSInteger)onePageCount{
    NSInteger count_line = [[self class]countInOneLine];
    return count_line*EmojiIMG_Lines-1;
}

+(EAMEmojiObj *)del_Obj{
    EAMEmojiObj * del_obj = [EAMEmojiObj new];
//    del_obj.emojiImgName = [NSString stringWithFormat:@"Face.bundle/%@",@"compose_emotion_delete"];
    del_obj.emojiImgName = [NSString stringWithFormat:@"%@",@"compose_emotion_delete"];
    return del_obj;
}


@end
