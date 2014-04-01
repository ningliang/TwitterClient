//
//  Tweet.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *tweetText;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *retweetedByUserScreenName;

@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSString *retweetId;

@property (nonatomic, strong) NSDate *createdAt;

- (NSString *)formattedAge;
- (NSString *)formattedDate;

- (void)toggleRetweet;
- (void)toggleFavorite;

+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary;

@end
