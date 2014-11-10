//
//  TipsCollectionViewCell.m
//  iOS_News
//
//  Created by Master on 2014/11/09.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#import "TipsCollectionViewCell.h"

@implementation TipsCollectionViewCell


- (void)setImageView:(UIImage *)image
{
    imageView.image = image;
}

- (void)setBottomImageView:(UIImage *)image
{
    bottomImageView.image = image;
}

- (void)setTitle:(NSString *)text
{
    // Label Setting
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = text;
}

@end
