//
//  MenuViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/7/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>

- (void)didClickHome;
- (void)didClickProfile;
- (void)didClickMentions;
- (void)didClickSignOut;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, assign) id<MenuDelegate> delegate;

@end
