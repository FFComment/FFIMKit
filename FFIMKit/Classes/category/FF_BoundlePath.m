//
//  FF_BoundlePath.m
//  FFIMKit
//
//  Created by Sunny_zhao on 2018/5/16.
//

#import "FF_BoundlePath.h"

@implementation FF_BoundlePath

+ (NSString *)ff_imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass oftype:(NSString *)type {
    
    NSBundle *currentBundle = [NSBundle bundleForClass:targetClass];
    NSString *name = nil;
    if ([type isEqualToString:@"png"]) {
        NSInteger scale = [[UIScreen mainScreen] scale];
        name = [NSString stringWithFormat:@"%@@%zdx",imageName,scale];
    }else {
        name = [NSString stringWithFormat:@"%@",imageName];
    }
    
    NSString *dir = [NSString stringWithFormat:@"%@.bundle",bundle];
    NSString *path = [currentBundle pathForResource:name ofType:type inDirectory:dir];
    return path ? path : nil;
}

@end
