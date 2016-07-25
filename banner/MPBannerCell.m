//
//  MPBannerCell.m
//  TemplateTest
//
//  Created by caijingpeng on 16/4/13.
//  Copyright © 2016年 caijingpeng.haowu. All rights reserved.
//

#import "MPBannerCell.h"

@implementation MPBannerCell

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (imageView == nil)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
    }
    return imageView;
}

@end
