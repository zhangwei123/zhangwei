//
//  MPBannerView.m
//  TemplateTest
//
//  Created by caijingpeng on 16/4/12.
//  Copyright © 2016年 caijingpeng.haowu. All rights reserved.
//

#import "MPBannerView.h"
#import "MPBannerCell.h"

@implementation MPBannerView

@synthesize banners;
@synthesize myCollectionView;
@synthesize pageCtrl;
@synthesize canCircleAnimate;
@synthesize autoStart;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.myCollectionView];
        [self addSubview:self.pageCtrl];
    }
    return self;
}

- (UICollectionView *)myCollectionView
{
    if (myCollectionView == nil)
    {
        UICollectionViewFlowLayout * flayout = [[UICollectionViewFlowLayout alloc]init];
        flayout.itemSize = self.bounds.size;
        flayout.minimumInteritemSpacing = 0;
        flayout.minimumLineSpacing = 0;
        flayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flayout];
        [collection registerClass:[MPBannerCell class] forCellWithReuseIdentifier:@"cell"];
        collection.delegate = self;
        collection.dataSource = self;
        collection.pagingEnabled = YES;
        collection.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:(myCollectionView = collection)];
    }
    return myCollectionView;
}

- (UIPageControl *)pageCtrl
{
    if (pageCtrl == nil)
    {
        UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        page.center = CGPointMake(CGRectGetMidX(self.myCollectionView.frame), CGRectGetMaxY(self.myCollectionView.frame) - 10);
        page.hidesForSinglePage = YES;
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        page.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:(pageCtrl = page)];
    }
    return pageCtrl;
}

- (void)setAutoStart:(BOOL)start
{
    autoStart = start;
    if (start)
    {
        [self startAnimate];
    }
    else
    {
        [self stopAnimate];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.virtualBanners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MPBannerModel *model = [self.virtualBanners objectAtIndex:indexPath.row];
    [Utility showPicWithUrl:model.imageUrl imageView:cell.imageView];
    
    return cell;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self stopAnimate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoStart)
    {
        [self startAnimate];
    }
    
    virtualIndex = scrollView.contentOffset.x / self.myCollectionView.bounds.size.width;
    [self setRealPage];
    
    if (canCircleAnimate)
    {
        if (virtualIndex == self.pageCtrl.numberOfPages + 1)
        {
            scrollView.contentOffset = CGPointMake(self.myCollectionView.bounds.size.width * 1, 0);
        }
        else if (virtualIndex == 0)
        {
            scrollView.contentOffset = CGPointMake(self.myCollectionView.bounds.size.width * (self.pageCtrl.numberOfPages), 0);
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (canCircleAnimate && autoStart)
    {
        if (virtualIndex == self.pageCtrl.numberOfPages + 1)
        {
            [self.myCollectionView setContentOffset:CGPointMake(self.myCollectionView.bounds.size.width * 1, 0) animated:NO];
            virtualIndex = 1;
        }
        else if (virtualIndex == 0)
        {
            [self.myCollectionView setContentOffset:CGPointMake(self.myCollectionView.bounds.size.width * (self.pageCtrl.numberOfPages), 0) animated:NO];
            virtualIndex = self.pageCtrl.numberOfPages;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setBanners:(NSArray *)b
{
    banners = b;
    self.pageCtrl.numberOfPages = b.count;
    self.pageCtrl.currentPage = 0;
    
    if (self.canCircleAnimate)
    {
        [self operateCircleAnimate];
    }
    else
    {
        self.virtualBanners = [NSMutableArray arrayWithArray:banners];
    }
    
    [self.myCollectionView reloadData];
}

- (void)setCanCircleAnimate:(BOOL)animate
{
    canCircleAnimate = animate;
    if (animate)
    {
        [self operateCircleAnimate];
    }
    else
    {
        self.virtualBanners = [NSMutableArray arrayWithArray:banners];
    }
    
    [self.myCollectionView reloadData];
    self.myCollectionView.contentOffset = CGPointMake(self.myCollectionView.bounds.size.width * 1, 0);
    
}

- (void)operateCircleAnimate
{
    if (self.banners.count > 1)
    {
        self.virtualBanners = [NSMutableArray array];
        [self.virtualBanners addObject:self.banners.lastObject];
        [self.virtualBanners addObjectsFromArray:self.banners];
        [self.virtualBanners addObject:self.banners.firstObject];
    }
}

- (void)startAnimate
{
    if (self.banners.count > 1)
    {
        [self stopAnimate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopAnimate
{
    if (self.timer != nil && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)autoScroll
{
    virtualIndex = (virtualIndex + 1) % self.virtualBanners.count;
    [self setRealPage];
//    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:virtualIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    if (canCircleAnimate)
    {
        [myCollectionView setContentOffset:CGPointMake(myCollectionView.bounds.size.width * virtualIndex, 0) animated:YES];
    }
    else
    {
        [myCollectionView setContentOffset:CGPointMake(myCollectionView.bounds.size.width * virtualIndex, 0) animated:YES];
    }
}

- (void)setRealPage
{
    if (canCircleAnimate)
    {
        NSInteger realIndex;
        if (virtualIndex == self.pageCtrl.numberOfPages + 1)
        {
            realIndex = 0;
        }
        else if (virtualIndex == 0)
        {
            realIndex = self.pageCtrl.numberOfPages - 1;
        }
        else
        {
            realIndex = virtualIndex - 1;
        }
        self.pageCtrl.currentPage = realIndex;
    }
    else
    {
        self.pageCtrl.currentPage = virtualIndex;
    }
    
}

- (void)dealloc
{
    [self stopAnimate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
