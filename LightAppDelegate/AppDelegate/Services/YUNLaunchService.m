//
//  YUNLaunchService.m
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import "YUNLaunchService.h"
#import "RootViewController.h"

@implementation YUNLaunchService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"AppDelegate ************ App has launched");
    
    return YES;
}

- (NSString *)serviceName {
    return NSStringFromClass([self class]);
}

@end
