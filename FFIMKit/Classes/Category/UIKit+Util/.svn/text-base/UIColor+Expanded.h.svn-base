//
//  UIColor+Expanded.h
//  edu_anhui_util
//
//  Created by yangjuanping on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Expanded)

#define VcBackgroudColor                [UIColor colorWithRGBHex:0xF3F4F6]
//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor colorWithRGBHex:V]

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
