//
//  EABTabLoadContext.h
//  edu_anhui_baseKit
//
//  Created by yangjuanping on 2017/4/27.
//
//

#import <Foundation/Foundation.h>

@interface EABTabLoadContext : NSObject
+ (instancetype)sharedInstance;
// 注册每个tab页对应的viewController
-(void)RegisterSubViewController:(Class)subViewControllerClass;

// 获取每个tab页对应的TabBarItem组成的数组
/* 此处dictionary格式定义同EABTabIconDelegate中itemOfTabViewController的返回格式
 */
-(NSArray<NSDictionary*>*)getMainTabModuleData;
@end
