//
//  YUNAppDelegateServicesManager.m
//  LightAppDelegate
//
//  Created by zhiyunyu on 2018/11/7.
//  Copyright © 2018 zhiyunyu. All rights reserved.
//

#import "YUNAppDelegateServicesManager.h"
#import "YUNAppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

//----------service--------
#import "YUNLaunchService.h"
#import "YUNAppStateServices.h"

@interface YUNAppDelegateServicesManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString*, id<YUNAppDelegateServiceProtocol>> *servicesMap;

@end

@implementation YUNAppDelegateServicesManager

- (instancetype)init {
    if (self = [super init]) {
        self.servicesMap = [[NSMutableDictionary alloc] init];
        
        //  注册服务
        [self registerService:[YUNLaunchService new]];
        [self registerService:[YUNAppStateServices new]];
    }
    return self;
}

#pragma mark Public Methods

+ (YUNAppDelegateServicesManager *)sharedInstance {
    static YUNAppDelegateServicesManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YUNAppDelegateServicesManager alloc] init];
    });
    return instance;
}

+ (NSArray<NSString *> *)appDelegateProtocolMethods {
    static NSMutableArray *methods = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned int methodCount = 0;
        methods = [NSMutableArray arrayWithCapacity:methodCount];
        
        // protocol UIApplicationDelegate
        struct objc_method_description *methodList = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &methodCount);
        for (int i = 0; i < methodCount; i ++) {
            struct objc_method_description md = methodList[i];
            [methods addObject:NSStringFromSelector(md.name)];
        }
        free(methodList);
        
        // class UIResponder, QNRemoteControlService需要用到
        Method *nsobject_method = class_copyMethodList([NSObject class], &methodCount);
        NSMutableArray *nbobjectMethods = [NSMutableArray array];
        for (int i = 0; i < methodCount; i ++) {
            Method md = nsobject_method[i];
            [nbobjectMethods addObject:NSStringFromSelector(method_getName(md))];
        }
        free(nsobject_method);
        NSSet *nsobjectMethodsSet = [NSSet setWithArray:nbobjectMethods];
        
        Method *methodList_responder = class_copyMethodList([UIResponder class], &methodCount);
        for (int i = 0; i < methodCount; i ++) {
            Method md = methodList_responder[i];
            NSString *methodName = NSStringFromSelector(method_getName(md));
            // 剔除掉NSObject的方法和私有方法
            if (![nsobjectMethodsSet containsObject:methodName] && ![methodName hasPrefix:@"_"]) {
                [methods addObject:methodName];
            }
        }
        free(methodList_responder);
    });
    return methods;
}

- (BOOL)servicesCanResponseToSelector:(SEL)aSelector {
    __block IMP imp = NULL;
    [self.servicesMap.allValues enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:aSelector]) {
            imp = [obj methodForSelector:aSelector];
            *stop = YES;
        }
    }];
    return imp != NULL && imp != _objc_msgForward;
}

- (void)servicesForwardInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *signature = anInvocation.methodSignature;
    NSUInteger argCount = signature.numberOfArguments;
    __block BOOL returnValue = NO;
    NSUInteger returnLength = signature.methodReturnLength;
    void * returnValueBytes = NULL;
    if (returnLength > 0) {
        returnValueBytes = alloca(returnLength);
    }
    
    [self.servicesMap.allValues enumerateObjectsUsingBlock:^(id<YUNAppDelegateServiceProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj respondsToSelector:anInvocation.selector]) {
            return;
        }
        // check the signature
        NSAssert([[self _objcTypesFromSignature:signature] isEqualToString:[self _objcTypesFromSignature:[(id)obj methodSignatureForSelector:anInvocation.selector]]],
                  @"Method signature for selector (%@) on (%@ - `%@`) is invalid. \
                  Please check the return value type and arguments type.",
                  NSStringFromSelector(anInvocation.selector), obj.serviceName, obj);
        
        // copy the invokation
        NSInvocation *invok = [NSInvocation invocationWithMethodSignature:signature];
        invok.selector = anInvocation.selector;
        // copy arguments
        for (NSUInteger i = 0; i < argCount; i ++) {
            const char * argType = [signature getArgumentTypeAtIndex:i];
            NSUInteger argSize = 0;
            NSGetSizeAndAlignment(argType, &argSize, NULL);
            
            void * argValue = alloca(argSize);
            [anInvocation getArgument:&argValue atIndex:i];
            [invok setArgument:&argValue atIndex:i];
        }
        // reset the target
        invok.target = obj;
        // invoke
        [invok invoke];
        
        // get the return value
        if (returnValueBytes) {
            [invok getReturnValue:returnValueBytes];
            returnValue = returnValue || *((BOOL *)returnValueBytes);
        }
    }];
    
    // set return value
    if (returnValueBytes) {
        [anInvocation setReturnValue:returnValueBytes];
    }
}

#pragma mark Private Methods
- (void)registerService:(id<YUNAppDelegateServiceProtocol>)service {
    if (!service) {
        return;
    }
    id<YUNAppDelegateServiceProtocol> exist = [self.servicesMap objectForKey:[service serviceName]];
    if (!exist) {
        [self.servicesMap setObject:service forKey:[service serviceName]];
    } else {
        NSAssert(service == exist, @"Try to register two different instance for service %@", [service serviceName]);
    }
}

- (void)unRegisterService:(id<YUNAppDelegateServiceProtocol>)service {
    if ([self.servicesMap.allKeys containsObject:[service serviceName]]) {
        [self.servicesMap removeObjectForKey:[service serviceName]];
    }
}

- (NSString *)_objcTypesFromSignature:(NSMethodSignature *)signature {
    NSMutableString *types = [NSMutableString stringWithFormat:@"%s", signature.methodReturnType?:"v"];
    for (NSUInteger i = 0; i < signature.numberOfArguments; i ++) {
        [types appendFormat:@"%s", [signature getArgumentTypeAtIndex:i]];
    }
    return [types copy];
}

@end
