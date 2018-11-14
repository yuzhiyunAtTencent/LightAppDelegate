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
    
    // 如果在appdelegate文件中要获取window,直接用self.window即可。
    [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; //设置窗口

    UIViewController *mainVC = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav; //进入的首个页面
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible]; //显示

    return YES;
}

- (NSString *)serviceName {
    return NSStringFromClass([self class]);
}

@end
