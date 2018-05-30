//
//  NSString+Pinyin.m
//  edu_anhui_util
//
//  Created by SmithLeo on 2017/6/13.
//
//

#import "NSString+Pinyin.h"

@implementation NSString(Pinyin)
-(NSString*)transChineseStringToPingyin {
    if ([self length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        }
        return ms;
    }
    return @"";
}
@end
