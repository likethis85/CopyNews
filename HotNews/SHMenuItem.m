//
//  SHMenuItem.m
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import "SHMenuItem.h"

@implementation SHMenuItem

- (id)init
{
    self = [super init];
    if (self)
    {
        _titleFont          = [UIFont boldSystemFontOfSize:16.f];
        _titleNormalColor   = [UIColor blackColor];
        _titleSelectedColor = [UIColor colorWithRed:0.752 green:0.026 blue:0.034 alpha:1.000];
    }
    
    return self;
}

@end
