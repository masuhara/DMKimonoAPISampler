//
//  DMTabMenu.m
//  iOS_News
//
//  Created by Master on 2014/11/18.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import "DMTabMenu.h"
#import "BKZoomView.h"

@implementation DMTabMenu
{
    BKZoomView *zoomView;
}

#pragma mark - Initialize

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.rowHeight = 70;
        [self setModel];
    }
    return self;
}


#pragma mark - Model
- (void)setModel
{
    self.menuArray = [[NSMutableArray alloc] init];
    self.menuArray = [NSMutableArray arrayWithObjects:@"検索モード", @"ソートモード", @"ルーペモード", nil];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"search.png"], [UIImage imageNamed:@"sort.png"], [UIImage imageNamed:@"wide.png"], nil];
    cell.imageView.image = imageArray[indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"KurokaneStd-EB" size:[UIFont systemFontSize]];
    
    
    return cell;
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", self.menuArray[indexPath.row]);
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            //[self removeFromSuperview];
            if (!zoomView) {
                [self makeZoomView];
            }else{
                [zoomView removeFromSuperview];
                zoomView = nil;
            }
            
            if (self) {
                [self dismissMenuView];
            }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)makeZoomView
{
    // ZoomView
    zoomView = [[BKZoomView alloc] initWithFrame:CGRectMake(10, 20, 150, 150)];
    [zoomView setZoomScale:2.0];
    [zoomView setDragingEnabled:YES];
    [zoomView.layer setBorderColor:[UIColor blackColor].CGColor];
    [zoomView.layer setBorderWidth:1.0];
    [zoomView.layer setCornerRadius:75];
    [self.superview addSubview:zoomView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [zoomView setNeedsDisplay];
}


- (void)dismissMenuView
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                             self.frame = CGRectMake(0, -210, self.frame.size.width, self.frame.size.height);
                     } completion:^(BOOL finished) {
                         NSLog(@"アニメーション終了");
                     }];
}


@end
