//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailViewController : UIViewController <ComposeTweetDelegate>

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) id<ComposeTweetDelegate> delegate;

@end
