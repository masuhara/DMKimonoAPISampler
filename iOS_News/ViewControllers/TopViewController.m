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

@interface TopViewController ()

@end

@implementation TopViewController
{
    IBOutlet UICollectionView *newsCollectionView;
    
    UIImageView *cellImageView;
    UIImageView *cellBottomImageView;
    UILabel *cellTitleLabel;
    UIRefreshControl *refreshControl;
    
    NSMutableArray *jsonArray;
    int numberOfArticle;
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
    newsCollectionView.backgroundView = [self setBackgroundView:[UIColor colorWithRed:247/255.0f green:246/255.0f blue:252/255.0f alpha:1.0]];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0f green:246/255.0f blue:252/255.0f alpha:1.0];
    
    
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
    newsCollectionView.alwaysBounceVertical = YES;
    refreshControl = [UIRefreshControl new];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新中..."];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [newsCollectionView addSubview:refreshControl];
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
    [cell setBackgroundColor:[UIColor colorWithRed:248/255.0f green:235/255.0f blue:245/255.0f alpha:1.0]];
    //[cell setImageView:[UIImage imageNamed:@"Xcode.png"]];
    
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
              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"データ取得エラー" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
              [alertView show];
              
          }else{
              //[SVProgressHUD dismiss];
          }
          
          loadSucceed = NO;
          
      }];
    return loadSucceed;
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
- (void)startRefresh:(id)sender
{
    [refreshControl beginRefreshing];
    
    BOOL isSucceed = [self getInformation];
    
    
    if (isSucceed == YES) {
        [newsCollectionView reloadData];
        [refreshControl endRefreshing];
    }else{
        [newsCollectionView reloadData];
        [refreshControl endRefreshing];
    }
    
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}




@end
