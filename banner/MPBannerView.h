//
//  MPBannerView.h
//  TemplateTest
//
//  Created by caijingpeng on 16/4/12.
//  Copyright © 2016年 caijingpeng.haowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBannerModel.h"

@interface MPBannerView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger virtualIndex;
}

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSMutableArray *virtualBanners;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UICollectionView *myCollectionView;
@property (nonatomic, weak) UIPageControl *pageCtrl;
@property (nonatomic, assign) BOOL canCircleAnimate;
@property (nonatomic, assign) BOOL autoStart;

- (void)startAnimate;
- (void)stopAnimate;

@end
