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


@end

@interface SHScrollPageView : UIView

@property (strong, nonatomic) id<SHScrollPageViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *pageViews;
//@property (strong, nonatomic) UIView *placeholderView;
@property (assign, nonatomic) NSUInteger pageCount;

- (void)setSelectedPage:(NSUInteger)selectedIndex animate:(BOOL)animate;
- (void)updateView;

@end
