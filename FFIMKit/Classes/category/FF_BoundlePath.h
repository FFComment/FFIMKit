//
//  FF_BoundlePath.h
//  FFIMKit
//
//  Created by Sunny_zhao on 2018/5/16.
//

#import <Foundation/Foundation.h>

@interface FF_BoundlePath : NSObject

+ (NSString *)ff_imagePathWithName:(NSString *)imageName bundle:(NSString *)bundle targetClass:(Class)targetClass oftype:(NSString *)type;
@end
