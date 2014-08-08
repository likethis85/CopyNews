//
//  SHScrollPageView.h
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHScrollPageView;

@protocol SHScrollPageViewDelegate <NSObject>

@optional
- (void)pageViewScrolling:(SHScrollPageView *)pageView scrollRatio:(CGFloat)ratio;
- (void)pageViewPageDidChanged:(SHScrollPageView *)pageView currentPage:(NSUInteger)currentPage;
@end

@interface SHScrollPageView : UIView

@property (strong, nonatomic) id<SHScrollPageViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *pageViews;
@property (assign, nonatomic) NSUInteger     pageCount;
@property (assign, nonatomic) NSUInteger     currentPage;
@property (strong, nonatomic) UIScrollView   *scrollView;
@property (assign, nonatomic) BOOL           hasPageControl;
@property (assign, nonatomic) BOOL           shouldObserve;// should observe scrollView contentOffset
@property (assign, nonatomic) BOOL           shouldNotify;  // nofity delegate when page changed

- (void)setSelectedPage:(NSUInteger)selectedIndex animate:(BOOL)animate;
- (void)updateView;

@end
