//
//  EABTabLoadContext.m
//  edu_anhui_baseKit
//
//  Created by yangjuanping on 2017/4/27.
//
//
#import <UIKit/UIKit.h>
#import "EABTabLoadContext.h"
#import "EABTabIconDelegate.h"


@interface EABTabLoadContext()
@property(nonatomic,strong)NSMutableDictionary<NSString *, Class>   *moduleClassesByName;
//@property(nonatomic,strong)NSArray* moduleData;
@end

@implementation EABTabLoadContext

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static EABTabLoadContext *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EABTabLoadContext alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        _moduleClassesByName = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)RegisterSubViewController:(Class)subViewControllerClass{
    NSParameterAssert(subViewControllerClass != nil);
    if ([_moduleClassesByName objectForKey:NSStringFromClass(subViewControllerClass)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ tab页已经注册过", NSStringFromClass(subViewControllerClass)] userInfo:nil];
    }
    
    NSString *key = NSStringFromClass(subViewControllerClass);
    [_moduleClassesByName setObject:subViewControllerClass forKey:key];
}

-(NSArray<NSDictionary*>*)getMainTabModuleData{
    NSMutableArray* arrItems = [[NSMutableArray alloc]init];
    for (Class cls in [_moduleClassesByName allValues]) {
        id subTabview = [[cls alloc]init];
        if ([subTabview conformsToProtocol:@protocol(EABTabIconDelegate)]) {
            UIViewController<EABTabIconDelegate>* vcTab = subTabview;
            if ([vcTab respondsToSelector:@selector(itemOfTabViewController)]) {
                NSDictionary* item = [vcTab itemOfTabViewController];
                //[arrItems addObject:item];
                NSInteger index = [item[@"index"] integerValue];
                if (index >= arrItems.count) {
                    [arrItems addObject:item];
                }
                else{
                    for (NSInteger i = 0; i < arrItems.count; i++) {
                        NSDictionary* itemTemp = arrItems[i];
                        if ([itemTemp[@"index"] integerValue]>index) {
                            [arrItems insertObject:item atIndex:i];
                            break;
                        }
                    }
                }
            }
        }
    }
    return arrItems;
}

@end
