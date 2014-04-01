//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

- (void)onReplyTweetClick;

@end
