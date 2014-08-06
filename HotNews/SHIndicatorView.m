//
//  SHIndicatorView.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHIndicatorView.h"

@implementation SHIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.752 green:0.026 blue:0.034 alpha:1.000];
    }
    return self;
}

+ (SHIndicatorView *)indicatorViewWithFrame:(CGRect)frame
{
    return [[SHIndicatorView alloc] initWithFrame:frame];
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    CGRect frame = self.frame;
    frame.size.height = indicatorHeight;
    self.frame = frame;
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth
{
    CGRect frame = self.frame;
    frame.size.width = indicatorWidth;
    self.frame = frame;
}

@end
