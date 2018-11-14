//
//  YUNAppDelegate.m
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import "YUNAppDelegate.h"
#import "YUNAppDelegateServicesManager.h"
#import <objc/message.h>

@interface YUNAppDelegate ()

@end

@implementation YUNAppDelegate

-(BOOL)respondsToSelector:(SEL)aSelector {
    BOOL canRespond = ([self methodForSelector:aSelector] != nil) && ([self methodForSelector:aSelector] != _objc_msgForward);
    if (!canRespond && [[YUNAppDelegateServicesManager appDelegateProtocolMethods] containsObject:NSStringFromSelector(aSelector)]) {
        canRespond = [[YUNAppDelegateServicesManager sharedInstance] servicesCanResponseToSelector:aSelector];
    }
    
    return canRespond;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    [[YUNAppDelegateServicesManager sharedInstance] servicesForwardInvocation:anInvocation];
}

@end
