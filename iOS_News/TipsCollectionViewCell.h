//
//  TipsCollectionViewCell.h
//  iOS_News
//
//  Created by Master on 2014/11/09.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsCollectionViewCell : UICollectionViewCell
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIImageView *bottomImageView;
    __weak IBOutlet UILabel *titleLabel;
}

- (void)setImageView:(UIImage *)image;
- (void)setBottomImageView:(UIImage *)image;
- (void)setTitle:(NSString *)text;

@end
