//
//  DMTabMenu.h
//  iOS_News
//
//  Created by Master on 2014/11/18.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTabMenu : UITableView
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic)NSMutableArray *menuArray;

@end
