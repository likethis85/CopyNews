//
//  SHMenuItem.h
//  HotNews
//
//  Created by p2p on 14-8-6.
//  Copyright (c) 2014年 Li Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMenuItem : NSObject

@property (copy, nonatomic  ) NSString *title;
@property (copy, nonatomic  ) UIFont   *titleFont;
@property (strong, nonatomic) UIColor  *titleNormalColor;
@property (strong, nonatomic) UIColor  *titleSelectedColor;

@end
