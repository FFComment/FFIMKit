//
//  EABTabIconDelegate.h
//  edu_anhui_baseKit
//
//  Created by yangjuanping on 2017/4/27.
//
//

#import <Foundation/Foundation.h>

@protocol EABTabIconDelegate <NSObject>

/* 此处dictionary格式定义如下：
 {@"title":NSString*, // 必选
 @"index":NSInterger, // 必选 index 从0开始
 @"imageNomal":NSString*, // 必选
 @"imageHightlight":NSString*, // 必选
 @"viewController":UIViewController*, // 必选
 @“rightBtn”：UIBarButton*,// 可选
 }
 */
-(NSDictionary*)itemOfTabViewController;
@end
