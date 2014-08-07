//
//  SHContentPageView.m
//  HotNews
//
//  Created by p2p on 14-8-7.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHContentPageView.h"

@interface SHContentPageView ()

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation SHContentPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)setPageCount:(NSUInteger)pageCount
{
    [super setPageCount:pageCount];
    _pageControl.numberOfPages = pageCount;
    [self _resizePageControl];
}

- (void)setSelectedPage:(NSUInteger)selectedIndex animate:(BOOL)animate
{
    [super setSelectedPage:selectedIndex animate:animate];
    if (selectedIndex >= _pageControl.numberOfPages)
        return;
    _pageControl.currentPage = selectedIndex;
}

#pragma mark - Private Methods
- (void)_resizePageControl
{
    CGSize controlSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
    CGRect frame = CGRectMake(0, 0, controlSize.width, controlSize.height);
    frame.origin.x = CGRectGetWidth(self.bounds) - controlSize.width - 10;
    frame.origin.y = CGRectGetHeight(self.bounds) - controlSize.height + 2;
    [_pageControl setFrame:frame];
}

@end
