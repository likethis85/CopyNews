//
//  SHScrollPageView.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHScrollPageView.h"

@interface SHScrollPageView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation SHScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

#pragma mark - Private Methods
- (void)_setup
{
    _currentPage = 0;
    _pageViews = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_pageControl];
}

- (CGRect)_frameForPageAtIndex:(NSUInteger)index
{
    return CGRectMake(index*CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)_resizePageControl
{
    _pageControl.hidden = !_hasPageControl;
    if (_hasPageControl)
    {
        CGSize controlSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        CGRect frame = CGRectMake(0, 0, controlSize.width, controlSize.height);
        frame.origin.x = CGRectGetWidth(self.bounds) - controlSize.width - 10;
        frame.origin.y = CGRectGetHeight(self.bounds) - controlSize.height + 2;
        [_pageControl setFrame:frame];
    }
}

#pragma mark - Public Methods
- (void)setSelectedPage:(NSUInteger)selectedIndex animate:(BOOL)animate
{
    if (selectedIndex >= _pageViews.count)
        return;
    
    _currentPage = selectedIndex;
    CGRect frame = [self _frameForPageAtIndex:selectedIndex];
    [_scrollView scrollRectToVisible:frame animated:animate];

    _pageControl.currentPage = selectedIndex;
}

- (void)updateView
{
    CGFloat contentWidth = _pageCount * CGRectGetWidth(self.bounds);
    [_scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.bounds))];
    
    for (int i = 0; i < _pageCount; i++)
    {
        CGRect frame = CGRectMake(i*CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        UIView *pageView = nil;
        if (i < _pageViews.count)
        {
            pageView = [_pageViews objectAtIndex:i];
        }
        else
        {
            UIView *placeholderView = [[UIView alloc] initWithFrame:self.bounds];
            UIImage *placeholderImage = [UIImage imageNamed:@"logo"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:placeholderImage];
            [imageView setFrame:self.bounds];
            [placeholderView addSubview:imageView];
            [placeholderView setFrame:frame];
            [_pageViews addObject:placeholderView];
            pageView = placeholderView;
        }
        [_scrollView addSubview:pageView];
    }
    
    _pageControl.hidden = !_hasPageControl;
    
    [self setSelectedPage:_currentPage animate:NO];
}

- (void)setPageCount:(NSUInteger)pageCount
{
    _pageCount = pageCount;
    
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat contentWidth = pageWidth * pageCount;
    [_scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.bounds))];
    _pageControl.numberOfPages = pageCount;
    [self _resizePageControl];
}

- (void)setHasPageControl:(BOOL)hasPageControl
{
    _hasPageControl = hasPageControl;
    [self _resizePageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    CGFloat offsetX   = scrollView.contentOffset.x;

    int currentPage = floor((offsetX - pageWidth/2)/pageWidth)+1;
    [self setSelectedPage:currentPage animate:YES];
}

@end
