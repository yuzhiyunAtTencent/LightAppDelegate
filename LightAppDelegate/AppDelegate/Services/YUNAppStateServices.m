//
//  YUNAppStateServices.m
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import "YUNAppStateServices.h"

@implementation YUNAppStateServices

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"AppDelegate ************ applicationWillResignActive");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"AppDelegate ************ applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"AppDelegate ************ applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"AppDelegate ************ applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"AppDelegate ************ applicationWillTerminate");
}


- (NSString *)serviceName {
    return NSStringFromClass([self class]);
}

@end
