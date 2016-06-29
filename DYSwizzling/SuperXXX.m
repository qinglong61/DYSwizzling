//
//  SuperXXX.m
//  testRuntime
//
//  Created by 段清伦 on 16/6/26.
//  Copyright © 2016年 duanyu. All rights reserved.
//

#import "SuperXXX.h"
#import <objc/runtime.h>

@implementation SuperXXX

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(test));
    Method newMethod = class_getInstanceMethod([self class], @selector(test1));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)test
{
    NSLog(@"Super test");
}

- (void)test1
{
    NSLog(@"Super test new");
}

- (void)DYSwizzling_test
{
    NSLog(@"will %@ test", NSStringFromClass(self.class));
    
    [self DYSwizzling_performSelector:@selector(test)];
    
    NSLog(@"did %@ test", NSStringFromClass(self.class));
}

@end
