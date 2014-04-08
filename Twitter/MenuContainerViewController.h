//
//  MenuContainerViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/7/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"
#import "MenuViewController.h"

@interface MenuContainerViewController : UIViewController

@property (nonatomic, strong) UINavigationController *tweetsViewNavController;
@property (nonatomic, strong) MenuViewController *menuViewController;

@end
