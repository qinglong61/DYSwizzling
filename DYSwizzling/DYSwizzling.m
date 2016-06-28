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
    [[self class] P_DYSwizzling_init];
}

+ (void)P_DYSwizzling_init
{
    [[self class] P_DYSwizzling_swizzling];
    
    static int onceToken = 1;
    if (onceToken) {
        onceToken = 0;
        NSArray *subclasses = P_DYSwizzling_getSubclasses([self class]);
        for (Class subclass in subclasses) {
            [subclass P_DYSwizzling_init];
        }
    }
}

+ (Method)P_DYSwizzling_getOldMethod:(Method)newMethod
{
    if (P_DYSwizzling_isSwizzlingMethod(newMethod)) {
        SEL oldSelector = NSSelectorFromString( [NSStringFromSelector(method_getName(newMethod)) substringFromIndex:[@"DYSwizzling_" length]] );
        Method oldMethod = class_getInstanceMethod([self class], oldSelector);
        if (NULL == oldMethod) {
            oldMethod = class_getClassMethod([self class], oldSelector);
        }
        return oldMethod;
    }
    return NULL;
}

+ (void)P_DYSwizzling_exchangeImplementationsIfNeed:(Method)method
{
    Method oldMethod = [[self class] P_DYSwizzling_getOldMethod:method];
    if (oldMethod) {
        static int onceToken = 1;
        static IMP new_imp;
        if (onceToken) {
            onceToken = 0;
            new_imp = method_getImplementation(method);
        }
        
        IMP old_imp = method_getImplementation(oldMethod);
        SEL tmpSelector = P_DYSwizzling_getTmpSelector(method_getName(oldMethod));
        class_addMethod([self class], tmpSelector, old_imp, NULL);
        method_setImplementation(oldMethod, new_imp);
        
        NSArray *subclasses = P_DYSwizzling_getSubclasses([self class]);
        for (Class subclass in subclasses) {
            [subclass P_DYSwizzling_exchangeImplementationsIfNeed:method];
        }
    }
}

+ (void)P_DYSwizzling_swizzling
{
    unsigned int outCount;
    Method *class_methodList = class_copyMethodList(object_getClass([self class]), &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        [[self class] P_DYSwizzling_exchangeImplementationsIfNeed:class_methodList[i]];
    }
    
    Method *instance_methodList = class_copyMethodList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        [[self class] P_DYSwizzling_exchangeImplementationsIfNeed:instance_methodList[i]];
    }
}

- (void)DYSwizzling_performSelector:(SEL)selector
{
    [self performSelector:P_DYSwizzling_getTmpSelector(selector)];
}

NSArray *P_DYSwizzling_getSubclasses(Class parentClass)
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)calloc(sizeof(Class), numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++) {
        Class superClass = classes[i];
        do{
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil) {
            continue;
        }
        [result addObject:classes[i]];
    }
    free(classes);
    return result;
}

BOOL P_DYSwizzling_isSwizzlingMethod(Method method)
{
    if ([NSStringFromSelector(method_getName(method)) isEqualToString:@"DYSwizzling_performSelector:"]) {
        return NO;
    }
    if ([NSStringFromSelector(method_getName(method)) hasPrefix:@"DYSwizzling_"]) {
        return YES;
    }
    return NO;
}

SEL P_DYSwizzling_getTmpSelector(SEL selector)
{
    return NSSelectorFromString([@"DYSwizzling_original_" stringByAppendingString:NSStringFromSelector(selector)]);
}

@end
