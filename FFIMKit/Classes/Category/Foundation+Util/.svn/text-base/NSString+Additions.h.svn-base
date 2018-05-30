//
//  NSString+Additions.h
//  edu_anhui_util
//
//  Created by yangjuanping on 2017/5/31.
//
//

#import <Foundation/Foundation.h>

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

@interface NSString (Additions)
- (NSString *)substringToFirstAppearanceOf:(unichar)target;
- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset;
- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset location:(NSUInteger *)location;
- (NSString *)substringFromFirstAppearanceOf:(unichar)target;
- (NSString *)substringFromFirstAppearanceOf:(unichar)target1 ToFirstAppearanceOf:(unichar)target2 FromIndex:(NSUInteger)beginIndex LastLocation:(NSUInteger *)lastLocation;
- (NSUInteger)locationOfFirstAppearanceOfSet:(NSCharacterSet *)charset from:(NSUInteger)location;
- (NSArray *)seperateByCharacter:(unichar)separate;
- (NSArray *)seperateByCharacters:(NSCharacterSet *)charset;
- (NSUInteger)findLastAppearanceOfSet:(NSCharacterSet *)charset ToIndex:(NSUInteger)endIndex;
- (BOOL)isSubstringOf:(NSString *)source CaseSensitive:(BOOL)casesensitive;
- (NSDictionary *)makeDictionary;
- (NSString *)substringFromLastAppearanceOf:(unichar)target;
- (NSString *)substringToLastAppearanceOf:(unichar)target;
- (BOOL)IsWhiteSpaceString;
- (NSString *)removeBlankSpace:(NSString *)currentStr;
@end
