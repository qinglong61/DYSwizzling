//
//  DYSwizzling.m
//  DYSwizzling
//
//  Created by duanqinglun on 16/6/24.
//  Copyright © 2016年 duan.yu. All rights reserved.
//

#import "DYSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (DYSwizzling)

+ (void)load
{
    [NSObject swizzling];
}

#pragma mark - Method Swizzling

+ (BOOL)isSwizzlingMethod:(Method)method
{
    if ([NSStringFromSelector(method_getName(method)) hasPrefix:@"DYSwizzling_"]) {
        return YES;
    }
    return NO;
}

+ (Method)getOldMethod:(Method)newMethod
{
    if ([NSObject isSwizzlingMethod:newMethod]) {
        SEL oldSelector = NSSelectorFromString( [NSStringFromSelector(method_getName(newMethod)) substringFromIndex:[@"DYSwizzling_" length]] );
        Method oldMethod = class_getInstanceMethod([self class], oldSelector);
        if (NULL == oldMethod) {
            oldMethod = class_getClassMethod([self class], oldSelector);
        }
        return oldMethod;
    }
    return NULL;
}

+ (void)exchangeImplementationsIfNeed:(Method)method
{
    if ([NSObject isSwizzlingMethod:method]) {
        Method oldMethod = [NSObject getOldMethod:method];
        if (oldMethod) {
            method_exchangeImplementations(oldMethod, method);
        }
    }
}

+ (void)swizzling
{
    unsigned int outCount;
    Method *class_methodList = class_copyMethodList(object_getClass([self class]), &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        [NSObject exchangeImplementationsIfNeed:class_methodList[i]];
    }
    
    Method *instance_methodList = class_copyMethodList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        [NSObject exchangeImplementationsIfNeed:instance_methodList[i]];
    }
}

@end
