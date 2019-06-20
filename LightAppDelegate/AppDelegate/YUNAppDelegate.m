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

/*
 * 如果不重写respondsToSelector，运行我们app并不会crash,但是会一片漆黑，因为app的入口函数都没有被调用，
 * 系统执行 delegate 的函数的时候，会先通过respondsToSelector询问下能否响应，如果不能响应就不执行了。
 * 所以我们需要重写它，然后追加自己的逻辑，最后系统找不到函数最终就会通过 forwardInvocation 提供一次转发消息的机会
*/
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
