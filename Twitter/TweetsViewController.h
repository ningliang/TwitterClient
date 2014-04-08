//
//  TweetsViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "TweetCell.h"
#import "TweetDetailViewController.h"
#import "ComposeTweetViewController.h"

@protocol TweetListDelegate <NSObject>

- (void) fetchTweets:(void (^)(NSArray *tweets))block withSinceId:(NSString *)sinceIdOrNil;

@end

@interface TweetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetDetailDelegate, ComposeTweetDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, assign) NSInteger targetUserId;
@property (nonatomic, assign) BOOL allowProfileVisit;

@property (nonatomic, assign) id<TweetListDelegate> delegate;

@end
