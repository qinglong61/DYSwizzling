//
//  SubXXX.m
//  testRuntime
//
//  Created by 段清伦 on 16/6/26.
//  Copyright © 2016年 duanyu. All rights reserved.
//

#import "SubXXX.h"
#import <objc/runtime.h>

@implementation SubXXX

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(test));
    Method newMethod = class_getInstanceMethod([self class], @selector(test1));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)test
{
    NSLog(@"sub test");
}

- (void)test1
{
    NSLog(@"sub test new");
}

@end

@implementation SubXXX1

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(test));
    Method newMethod = class_getInstanceMethod([self class], @selector(test1));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)test
{
    NSLog(@"sub test1");
}

- (void)test1
{
    NSLog(@"sub test1 new");
}

@end
