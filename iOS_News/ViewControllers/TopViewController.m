//
//  TopViewController.m
//  iOS_News
//
//  Created by Master on 2014/11/08.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import "TopViewController.h"
#import "TipsCollectionViewCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "KIProgressViewManager.h"






@interface TopViewController ()
<EGORefreshTableHeaderDelegate, UIAlertViewDelegate>
@end

@implementation TopViewController
{
    IBOutlet UICollectionView *newsCollectionView;
    
    UIImageView *cellImageView;
    UIImageView *cellBottomImageView;
    UILabel *cellTitleLabel;
    NSMutableArray *jsonArray;
    int numberOfArticle;
    BOOL isReloading;
    
    EGORefreshTableHeaderView *headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // AFNetwirking CacheDelete
    [self deleteAFNetworkingCache];
    
    // AFNetworking Connection
    [self getInformation];
    
    // CollectionView Delegate & DataSource
    newsCollectionView.dataSource = self;
    newsCollectionView.delegate   = self;
    
    // BackGroundColor (Pastel White)
    newsCollectionView.backgroundView = [self setBackgroundView:BASE_COLOR];
    self.view.backgroundColor = BASE_COLOR;
    
    // BackGroundImage
    /*
    newsCollectionView.backgroundView = [self setBackgroundViewWithImage:[UIImage imageNamed:@""]];
     */
    
    
    
    if (!jsonArray) {
        jsonArray = [NSMutableArray new];
    }
    
    // SVProgressHUD
    //[SVProgressHUD showWithStatus:@"読み込み中" maskType:SVProgressHUDMaskTypeGradient];
    
    // Pull to Refresh
    if (headerView == nil) {
        // 更新ビューのサイズとデリゲートを指定する
        headerView =
        [[EGORefreshTableHeaderView alloc] initWithFrame:
         CGRectMake(
                    0.0f,
                    0.0f - newsCollectionView.bounds.size.height,
                    self.view.frame.size.width,
                    newsCollectionView.bounds.size.height
                    )];
        headerView.delegate = self;
        [newsCollectionView addSubview:headerView];
    }
    // 最終更新日付を記録
    [headerView refreshLastUpdatedDate];
    
    // iOS7でRefresh後にNavigationBarに隠れる問題の対処
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // KIProgressView
    [self makeKIProgressView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - BackGround
- (UIView *)setBackgroundView:(UIColor *)color
{
    UIView *bgView = [UIView new];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgView.backgroundColor = color;
    return bgView;
}


- (UIImageView *)setBackgroundViewWithImage:(UIImage *)bgImage
{
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    bgImageView.image = bgImage;
    return bgImageView;
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return numberOfArticle;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TipsCollectionViewCell *cell = (TipsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *titleArray = [[jsonArray valueForKey:@"article"] valueForKey:@"text"];
    //NSLog(@"%@",titleArray[indexPath.row]);
    
    
    [cell setTitle:titleArray[indexPath.row]];
    
    // Sakura Color
    [cell setBackgroundColor:CONSEPT_COLOR];
    //[cell setImageView:[UIImage imageNamed:@"Xcode.png"]];
    
    // Coner radius
    cell.layer.cornerRadius = 9.0;
    cell.clipsToBounds = YES;
    
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped ==> %d", (int)indexPath.row);
    [self performSegueWithIdentifier:@"detail" sender:nil];
}



#pragma mark - AFNetworking
- (BOOL)getInformation
{
    // showKIProgressView
    [[KIProgressViewManager manager] showProgressOnView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __block BOOL loadSucceed = NO;
    
    //NSDictionary *params = @{@"count":@20};
    [manager GET:@"https://www.kimonolabs.com/api/at66pv4o?apikey=lYvFFCKdhryhIifZUXQE48Xdeeqmgnie"
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          //TODO:
          jsonArray = [[responseObject valueForKey:@"results"] valueForKey:@"collection"];
          
          NSLog(@"JSON: %@", jsonArray);
          numberOfArticle = (int)jsonArray.count;
          
          if ([[operation valueForKey:@"state"] intValue] == 3) {
              //[SVProgressHUD dismiss];
              loadSucceed = YES;
              [newsCollectionView reloadData];
          }
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          
          if (error) {
              //[SVProgressHUD dismiss];
              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"データ取得エラー" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"リロード", nil];
              [alertView show];
          }
          
          loadSucceed = NO;
          
      }];
    return loadSucceed;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self getInformation];
            break;
            
        default:
            break;
    }
}


- (void)deleteAFNetworkingCache
{
    NSInteger diskCapacity = [NSURLCache sharedURLCache].diskCapacity;
    NSInteger memoryCapacity = [NSURLCache sharedURLCache].memoryCapacity;
    
    [NSURLCache sharedURLCache].diskCapacity = 0;
    [NSURLCache sharedURLCache].memoryCapacity = 0;
    [NSURLCache sharedURLCache].diskCapacity = diskCapacity;
    [NSURLCache sharedURLCache].memoryCapacity = memoryCapacity;
    
    [newsCollectionView reloadData];
}

#pragma mark - Refresh
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    [self getInformation];
    isReloading = YES;
}

- (void)doneLoadingTableViewData{
    //  model should call this when its done loading
    isReloading = NO;
    [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:newsCollectionView];
    
}


#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return isReloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}



#pragma mark - KIProgressView

- (void)makeKIProgressView
{
    // Set the color
    [[KIProgressViewManager manager] setColor:[UIColor redColor]];
    
    // Set the gradient
    [[KIProgressViewManager manager] setGradientStartColor:[UIColor blackColor]];
    [[KIProgressViewManager manager] setGradientEndColor:[UIColor whiteColor]];
    
    // Currently not supported
    [[KIProgressViewManager manager] setStyle:KIProgressViewStyleRepeated];
}



#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
