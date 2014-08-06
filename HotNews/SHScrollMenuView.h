//
//  SHScrollMenuView.h
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHScrollMenuView;

@protocol SHScrollMenuViewDelegate <NSObject>

- (void)scrollMenuDidSelectedItem:(SHScrollMenuView *)menuView selectedIndex:(NSInteger)selectedIndex;
- (void)scrollMenuManagerSelected:(SHScrollMenuView *)menuView;

@end

@interface SHScrollMenuView : UIView

@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, nonatomic) id<SHScrollMenuViewDelegate> delegate;

- (void)setSelectedMenuItem:(NSInteger)selectedIndex animate:(BOOL)animate;
- (void)updateView;

@end
