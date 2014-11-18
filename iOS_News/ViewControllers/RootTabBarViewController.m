//
//  RootTabBarViewController.m
//  iOS_News
//
//  Created by Master on 2014/11/08.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "DMTabMenu.h"


@interface RootTabBarViewController ()

@end


@implementation RootTabBarViewController
{
    DMTabMenu *menuTable;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation Bar Setting
    [self setNavigationBar];
    
    // make MenuView
    menuTable = [[DMTabMenu alloc] initWithFrame:CGRectMake(0, -210, self.view.frame.size.width, 210)];
    [self.view addSubview:menuTable];


    //[UITabBar appearance].barTintColor = [UIColor brownColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation Bar
- (void)setNavigationBar
{
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    menuButton.showsTouchWhenHighlighted = YES;
    menuButton.frame = CGRectMake(0, 0, 30, 30);
    [menuButton addTarget:self action:@selector(tappedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)tappedMenuButton:(id)sender
{
    // MenuItems
    if (menuTable.frame.origin.y != 0) {
        [self makeMenu];
    }else{
        [self dismissMenu];
    }
}

- (void)makeMenu
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         menuTable.frame = CGRectMake(0, 0, self.view.frame.size.width, 210);
                     } completion:^(BOOL finished) {
                         NSLog(@"アニメーション終了");
                     }];
}

- (void)dismissMenu
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         menuTable.frame = CGRectMake(0, -210, self.view.frame.size.width, 210);
                     } completion:^(BOOL finished) {
                         NSLog(@"アニメーション終了");
                     }];
}



@end
