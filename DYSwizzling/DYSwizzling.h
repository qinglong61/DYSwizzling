//
//  DYSwizzling.h
//  DYSwizzling
//
//  Created by duanqinglun on 16/6/24.
//  Copyright © 2016年 duan.yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSObject (DYSwizzling)

- (void)DYSwizzling_performSelector:(SEL)selector;

@end
