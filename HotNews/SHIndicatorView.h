//
//  SHIndicatorView.h
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHIndicatorView : UIView

@property (assign, nonatomic) CGFloat indicatorHeight;
@property (assign, nonatomic) CGFloat indicatorWidth;

+ (SHIndicatorView *)indicatorViewWithFrame:(CGRect)frame;

@end
