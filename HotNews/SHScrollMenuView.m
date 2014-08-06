//
//  SHScrollMenuView.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHScrollMenuView.h"
#import "SHMenuItem.h"
#import "SHIndicatorView.h"

const CGFloat kMenuButtonMargin = 5;
const CGFloat kMenuIndicatorHeight = 3;

@interface SHScrollMenuView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView  *leftShadowImageView;
@property (strong, nonatomic) UIImageView  *rightShadowImageView;
@property (strong, nonatomic) UIButton     *managerButton;
@property (strong, nonatomic) SHIndicatorView *indicatorView;

@property (strong, nonatomic) NSMutableArray *menuButtons;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation SHScrollMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

#pragma mark - Public Methods
- (void)setSelectedMenuItem:(NSInteger)selectedIndex animate:(BOOL)animate
{
    if (selectedIndex >= _menuItems.count)
        return ;
    
    _selectedIndex = selectedIndex;
    
    // set button state
    UIButton *selectedButton = [_menuButtons objectAtIndex:selectedIndex];
    [_menuButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *menuButton = (UIButton *)obj;
        menuButton.selected = [menuButton isEqual:selectedButton];
    }];
    
    // update indicator frame
    CGRect frame = [self _frameForItemAtIndex:_selectedIndex];
    frame.origin.y = CGRectGetHeight(self.bounds)-kMenuIndicatorHeight;
    frame.size.height = kMenuIndicatorHeight;
    if (animate)
    {
        [UIView animateWithDuration:0.2f animations:^{
            [_indicatorView setFrame:frame];
        }];
    }
    else
    {
        [_indicatorView setFrame:frame];
    }
    
    // make button frame visible
    [_scrollView scrollRectToVisible:frame animated:animate];
}

- (void)updateView
{
    for (UIButton *menuButton in _menuButtons)
    {
        [menuButton removeFromSuperview];
    }
    
    for (SHMenuItem *menuItem in _menuItems)
    {
        UIButton *menuButton = [self _getUIButtonWithMenuItem:menuItem];
        [_menuButtons addObject:menuButton];
    }
    
    CGFloat contentWidth = CGRectGetMaxX(_leftShadowImageView.frame);
    for (NSInteger i = 0; i < _menuButtons.count; i++)
    {
        UIButton *menuButton = [_menuButtons objectAtIndex:i];
        CGRect menuFrame = menuButton.frame;
        contentWidth += CGRectGetWidth(menuFrame);
        if (i == 0) // first menu item
        {
            menuFrame.origin.x = CGRectGetMaxX(_leftShadowImageView.frame);
        }
        else
        {
            CGRect prevItemFrame = [self _frameForItemAtIndex:i-1];
            menuFrame.origin.x = prevItemFrame.origin.x + CGRectGetWidth(menuFrame);
        }
        menuFrame.origin.y = CGRectGetMidY(self.bounds) - CGRectGetHeight(menuFrame)/2;
        [menuButton setFrame:menuFrame];
        
        [_scrollView addSubview:menuButton];
        [_scrollView setContentSize:CGSizeMake(contentWidth, CGRectGetHeight(self.scrollView.frame))];
        
        _rightShadowImageView.hidden = NO;
    }
    
    [self setSelectedMenuItem:_selectedIndex animate:NO];
}

#pragma mark - Private Methods
- (void)_setup
{
    _selectedIndex = 0;
    _menuItems = [[NSMutableArray alloc] init];
    _menuButtons = [[NSMutableArray alloc] initWithCapacity:_menuItems.count];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _leftShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftShadow"]];
    _leftShadowImageView.hidden = YES;
    
    _rightShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightShadow"]];
    _rightShadowImageView.hidden = YES;
    
    // for manager button
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width  = height;
    _managerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - width, 0, width, height)];
    [_managerButton setImage:[UIImage imageNamed:@"managerMenuButton"] forState:UIControlStateNormal];
    _managerButton.backgroundColor = self.backgroundColor;
    _managerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_managerButton addTarget:self action:@selector(_menuManagerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // for right shaow frame
    CGRect shadowViewFrame = _rightShadowImageView.frame;
    shadowViewFrame.origin = CGPointMake(CGRectGetMinX(_managerButton.frame) - CGRectGetWidth(_rightShadowImageView.frame), 0);
    _rightShadowImageView.frame = shadowViewFrame;
    
    // menu scroll view
    CGFloat scrollViewWidth = CGRectGetWidth(self.bounds)-CGRectGetMinX(_leftShadowImageView.frame)-CGRectGetWidth(_rightShadowImageView.frame) - CGRectGetWidth(_managerButton.frame);
    CGRect scrollViewFrame = CGRectMake(CGRectGetMinX(_leftShadowImageView.frame), 0, scrollViewWidth, CGRectGetHeight(self.bounds));
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.backgroundColor = self.backgroundColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _indicatorView = [SHIndicatorView indicatorViewWithFrame:CGRectZero];
    [_scrollView addSubview:_indicatorView];
    
    [self addSubview:_scrollView];
    [self addSubview:_leftShadowImageView];
    [self addSubview:_rightShadowImageView];
    [self addSubview:_managerButton];
}

- (CGRect)_frameForItemAtIndex:(NSUInteger)index
{
    if (index >= _menuButtons.count)
        return CGRectZero;
    return ((UIButton *)[_menuButtons objectAtIndex:index]).frame;
}

- (UIButton *)_getUIButtonWithMenuItem:(SHMenuItem *)menuItem
{
    NSString *title = menuItem.title;
    if (title == nil)
        return nil;
    
    UIFont *titleFont = menuItem.titleFont ? menuItem.titleFont : [UIFont systemFontOfSize:16.f];
//    UIColor *titleColor = menuItem.
    CGSize buttonSize = [title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    buttonSize.width += 2*kMenuButtonMargin;
    buttonSize.height = CGRectGetHeight(self.bounds);
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    menuButton.titleLabel.font = titleFont;
//    menuButton setTitleColor:<#(UIColor *)#> forState:<#(UIControlState)#>
    [menuButton setTitle:menuItem.title forState:UIControlStateNormal];
    [menuButton setTitle:menuItem.title forState:UIControlStateHighlighted];
    [menuButton setTitle:menuItem.title forState:UIControlStateSelected];
    [menuButton setTitleColor:menuItem.titleNormalColor forState:UIControlStateNormal];
    [menuButton setTitleColor:menuItem.titleSelectedColor forState:UIControlStateSelected];
    [menuButton addTarget:self action:@selector(_menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return menuButton;
}

- (void)_menuButtonAction:(UIButton *)sender
{
    NSInteger index = [_menuButtons indexOfObject:sender];
    if (index == NSNotFound)
        return;
    [self setSelectedMenuItem:index animate:YES];
}

- (void)_menuManagerButtonAction:(UIButton *)sender
{
    
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat contentWidth = scrollView.contentSize.width;
    CGFloat scrollViewWidth = CGRectGetWidth(scrollView.bounds);
    if (contentWidth <= scrollViewWidth)
    {
        _leftShadowImageView.hidden = YES;
        _rightShadowImageView.hidden = YES;
    }
    else
    {
        _leftShadowImageView.hidden = !(contentOffsetX > 0);
        _rightShadowImageView.hidden = (contentOffsetX+scrollViewWidth >= contentWidth);
    }
}

@end
