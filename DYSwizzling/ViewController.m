//
//  ViewController.m
//  DYSwizzling
//
//  Created by duanqinglun on 16/6/24.
//  Copyright © 2016年 duan.yu. All rights reserved.
//

#import "ViewController.h"
#import "DYSwizzling.h"

@interface ViewController (DYSwizzling)

@end

@implementation ViewController (DYSwizzling)

- (void)DYSwizzling_loadView
{
    [self DYSwizzling_loadView];
    NSLog(@"did invoke loadView");
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
