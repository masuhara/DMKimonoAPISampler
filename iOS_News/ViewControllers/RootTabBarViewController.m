//
//  RootTabBarViewController.m
//  iOS_News
//
//  Created by Master on 2014/11/08.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import "RootTabBarViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[UITabBar appearance].barTintColor = [UIColor brownColor];
    
    [UITabBar appearance].backgroundImage = [UIImage imageNamed:@"tab_background"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
