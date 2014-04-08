//
//  AppDelegate.h
//  Twitter
//
//  Created by Ning Liang on 3/31/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "MenuContainerViewController.h"
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *loginViewNavController;
@property (strong, nonatomic) MenuContainerViewController *menuContainerViewController;

- (void)updateRootViewController;

@end
