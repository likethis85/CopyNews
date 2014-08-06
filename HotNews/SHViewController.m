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

@interface SHViewController ()

@property (strong, nonatomic) SHScrollMenuView *menuView;

@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _menuView = [[SHScrollMenuView alloc] initWithFrame:CGRectMake(0, 22, CGRectGetWidth(self.view.bounds), 36)];
    for (int i = 0; i < 10; i++)
    {
        SHMenuItem *menuItem = [[SHMenuItem alloc] init];
        menuItem.title = [NSString stringWithFormat:@"菜单-%d", i];
        [_menuView.menuItems addObject:menuItem];
    }
    _menuView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    [_menuView updateView];
    [self.view addSubview:_menuView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
