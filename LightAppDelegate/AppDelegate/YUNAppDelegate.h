//
//  YUNAppDelegate.h
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YUNAppDelegateServiceProtocol <UIApplicationDelegate>
- (NSString *)serviceName;
@end

@interface YUNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

