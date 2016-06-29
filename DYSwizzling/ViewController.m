//
//  ViewController.m
//  DYSwizzling
//
//  Created by duanqinglun on 16/6/24.
//  Copyright © 2016年 duan.yu. All rights reserved.
//

#import "ViewController.h"
#import "SubXXX.h"
#import "SuperXXX.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SubXXX *xxx = [[SubXXX alloc] init];
    [xxx test];
    
    SubXXX1 *xxx1 = [[SubXXX1 alloc] init];
    [xxx1 test];
    
    SuperXXX *xxxS = [[SuperXXX alloc] init];
    [xxxS test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
