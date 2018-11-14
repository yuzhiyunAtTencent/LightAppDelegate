//
//  YUNAppDelegateServicesManager.h
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUNAppDelegateServicesManager : NSObject

+ (instancetype)sharedInstance;
+ (NSArray<NSString *> *)appDelegateProtocolMethods;

- (void)servicesForwardInvocation:(NSInvocation *)anInvocation;
- (BOOL)servicesCanResponseToSelector:(SEL)aSelector;

@end
