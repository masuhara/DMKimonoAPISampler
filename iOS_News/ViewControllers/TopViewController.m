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
    
    NSMutableArray *jsonArray;
    int numberOfArticle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // AFNetwirking CacheDelete
    [self deleteAFNetworkingCache];
    
    // CollectionView Delegate & DataSource
    newsCollectionView.dataSource = self;
    newsCollectionView.delegate   = self;
    
    // BackGroundColor
    newsCollectionView.backgroundView = [self setBackgroundView:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // BackGroundImage
    /*
    newsCollectionView.backgroundView = [self setBackgroundViewWithImage:[UIImage imageNamed:@""]];
     */
    
    if (!jsonArray) {
        jsonArray = [NSMutableArray new];
    }
    
    //[SVProgressHUD showWithStatus:@"読み込み中" maskType:SVProgressHUDMaskTypeGradient];
}

- (void)viewDidAppear:(BOOL)animated
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"count":@20};
    [manager GET:@"https://www.kimonolabs.com/api/at66pv4o?apikey=lYvFFCKdhryhIifZUXQE48Xdeeqmgnie"
      parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //TODO:
        jsonArray = [[responseObject valueForKey:@"results"] valueForKey:@"collection"];
        
        NSLog(@"JSON: %@", jsonArray);
        numberOfArticle = (int)jsonArray.count;
        
        if ([[operation valueForKey:@"state"] intValue] == 3) {
            //[SVProgressHUD dismiss];
            [newsCollectionView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (!error) {
            //[SVProgressHUD dismiss];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"データ取得エラー" message:@"データの取得に失敗しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
        }else{
            //[SVProgressHUD dismiss];
        }
    }];
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
    [cell setImageView:[UIImage imageNamed:@"Xcode.png"]];
    
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped ==> %d", (int)indexPath.row);
}



#pragma mark - AFNetworking
- (void)deleteAFNetworkingCache
{
    NSInteger diskCapacity = [NSURLCache sharedURLCache].diskCapacity;
    NSInteger memoryCapacity = [NSURLCache sharedURLCache].memoryCapacity;
    /* 0にする */
    [NSURLCache sharedURLCache].diskCapacity = 0;
    [NSURLCache sharedURLCache].memoryCapacity = 0;
    /* もとの大きさに戻す */
    [NSURLCache sharedURLCache].diskCapacity = diskCapacity;
    [NSURLCache sharedURLCache].memoryCapacity = memoryCapacity;
    
    [newsCollectionView reloadData];
}





@end
