//
//  ProfileViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/8/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TweetsViewController.h"

@interface ProfileViewController : UIViewController <TweetListDelegate, ComposeTweetDelegate>

@property (nonatomic, assign) NSInteger userId;

- (id)initWithUserId:(NSInteger)userId;

@end
