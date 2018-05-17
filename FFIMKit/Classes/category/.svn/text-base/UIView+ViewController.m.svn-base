//
//  UIView+ViewController.m
//  FenggeBeautifulClothesApp
//
//  Created by liyexiang on 14-7-22.
//  Copyright (c) 2014年 Liyexiang. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

/**********************************************************
 函数名称：viewController
 函数描述：获取view最近的控制器。
 输入参数：N/A
 输出参数：N/A
 返回值：UIViewController。
 **********************************************************/
-(UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
