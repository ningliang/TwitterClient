//
//  Tweet.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)formattedAge {
    return @"hi";
}

// TODO network call
- (void)toggleRetweet {
    if (self.retweeted) {
        self.retweetCount -= 1;
    } else {
        self.retweetCount += 1;
    }
    self.retweeted = !self.retweeted;
}

// TODO network call
- (void)toggleFavorite {
    if (self.favorited) {
        self.favoriteCount -= 1;
    } else {
        self.favoriteCount += 1;
    }
    self.favorited = !self.favorited;
}

+ (Tweet *)tweetWithDictionary:(NSDictionary *)dictionary {
    Tweet *tweet = [[Tweet alloc] init];
    
    tweet.tweetText = dictionary[@"text"];
    tweet.user = [User userWithDictionary:dictionary[@"user"]];
    tweet.retweetCount = [dictionary[@"retweets"] integerValue];
    
    tweet.retweeted = [dictionary[@"retweeted"] integerValue] == 1;
    tweet.favorited = [dictionary[@"favorited"] integerValue] == 1;
    tweet.favoriteCount = [dictionary[@"favorite_count"] integerValue];
    tweet.retweetCount = [dictionary[@"retweeted_count"] integerValue];

    return tweet;
}

@end
