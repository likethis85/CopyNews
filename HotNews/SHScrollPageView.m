//
//  SHScrollPageView.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHScrollPageView.h"

NSString * kContentOffsetKey = @"contentOffset";

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

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:kContentOffsetKey];
}

#pragma mark - Private Methods
- (void)_setup
{
    _currentPage = 0;
    _shouldObserve = NO;
    _pageViews = [[NSMutableArray alloc] init];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [self.scrollView addObserver:self forKeyPath:kContentOffsetKey options:0 context:NULL];
    
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
    
    if (_shouldNotify)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(pageViewPageDidChanged:currentPage:)])
        {
            [_delegate pageViewPageDidChanged:self currentPage:_currentPage];
        }
    }
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_shouldObserve && [keyPath isEqualToString:kContentOffsetKey])
    {
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        CGFloat currentX  = _currentPage * pageWidth;
        if (currentX != offsetX)
        {
            BOOL direction = (currentX > offsetX);
            NSInteger index = direction ? (_currentPage-1) : (_currentPage + 1);
            if (index < 0 || index >= _pageCount)
                return;
            CGFloat ratio = (offsetX - currentX) / pageWidth;
            if (_delegate && [_delegate respondsToSelector:@selector(pageViewScrolling:scrollRatio:)])
            {
                [_delegate pageViewScrolling:self scrollRatio:ratio];
            }
        }
    }
}

@end
