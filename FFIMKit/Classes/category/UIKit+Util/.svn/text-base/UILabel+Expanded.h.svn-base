//
//  UILable+Expanded.h
//  edu_anhui_util
//
//  Created by SmithLeo on 2017/6/6.
//
//

#import <UIKit/UIKit.h>

@interface UILabel(Expanded)
//设置行间距
- (void)labelText:(NSString *)text
      lineSpacing:(CGFloat)l_spacing;

//设置段间距和行间距
- (void)labelText:(NSString *)text
   sectionSpacing:(CGFloat)s_spacing
      lineSpacing:(CGFloat)l_spacing;

//设置单纯富文本
+ (NSAttributedString *)attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts;

//设置带行间距的富文本
+ (NSAttributedString *)attributedTextArray:(NSArray *)texts
                                 textColors:(NSArray *)colors
                                  textfonts:(NSArray *)fonts
                                lineSpacing:(CGFloat)l_spacing;

//富文本的LableSize
+ (CGSize)sizeLabelWidth:(CGFloat)width
          attributedText:(NSAttributedString *)attributted;

//纯文本的LableSize
+ (CGSize)sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font;

//带行间距的纯文本的LableSize
+ (CGSize)sizeLabelWidth:(CGFloat)width
                    text:(NSString *)text
                    font:(UIFont *)font
             lineSpacing:(CGFloat)l_spacing;



@end
