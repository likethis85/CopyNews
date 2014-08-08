//
//  SHViewController.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHViewController.h"
#import "SHScrollMenuView.h"
#import "SHMenuItem.h"
#import "SHScrollPageView.h"

@interface SHViewController () <SHScrollMenuViewDelegate, SHScrollPageViewDelegate>

@property (strong, nonatomic) SHScrollMenuView *menuView;
@property (strong, nonatomic) SHScrollPageView *pageView;

@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _menuView = [[SHScrollMenuView alloc] initWithFrame:CGRectMake(0, 22, CGRectGetWidth(self.view.bounds), 36)];
    _pageView = [[SHScrollPageView alloc] initWithFrame:CGRectMake(0, 22+36, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-22-36)];
//    for (int i = 0; i < 10; i++)
    {
        SHMenuItem *menuItem = [[SHMenuItem alloc] init];
        menuItem.title = [NSString stringWithFormat:@"热点"];
        [_menuView.menuItems addObject:menuItem];
    }
    {
        SHMenuItem *menuItem = [[SHMenuItem alloc] init];
        menuItem.title = [NSString stringWithFormat:@"轻松一刻"];
        [_menuView.menuItems addObject:menuItem];
    }
    {
        SHMenuItem *menuItem = [[SHMenuItem alloc] init];
        menuItem.title = [NSString stringWithFormat:@"很长很长的名字"];
        [_menuView.menuItems addObject:menuItem];
    }
    _menuView.delegate = self;
    _menuView.shouldNotify = YES;
    _menuView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    [_menuView updateView];
    [self.view addSubview:_menuView];
    
    NSUInteger pageCount = _menuView.menuItems.count;
    [_pageView setPageCount:pageCount];
    _pageView.hasPageControl = NO;
    _pageView.delegate = self;
    _pageView.shouldObserve = YES;
    _pageView.shouldNotify = YES;
    [_pageView updateView];
    [self.view addSubview:_pageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll Menu Delegate
- (void)scrollMenuDidSelectedItem:(SHScrollMenuView *)menuView selectedIndex:(NSInteger)selectedIndex
{
    [_pageView setSelectedPage:selectedIndex animate:NO];
}

- (void)scrollMenuManagerSelected:(SHScrollMenuView *)menuView
{
    
}

#pragma mark - Page View Delegage
- (void)pageViewScrolling:(SHScrollPageView *)pageView scrollRatio:(CGFloat)ratio
{
    [_menuView updateIndicatorFrame:ratio];
}

- (void)pageViewPageDidChanged:(SHScrollPageView *)pageView currentPage:(NSUInteger)currentPage
{
    [_menuView setSelectedMenuItem:currentPage animate:YES notify:NO];
}

@end
