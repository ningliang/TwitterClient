//
//  TweetCell.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailDelegate <NSObject>

- (void)didRetweet:(id)sender;
- (void)didFavorite:(id)sender;
- (void)didReply:(id)sender;

@end


@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, assign) id<TweetDetailDelegate> delegate;

- (void)onReply;
- (void)onRetweet;
- (void)onFavorite;
- (void)refresh;

@end
