//
//  Tweet.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

- (NSString *)formattedAge {
    NSDate *now = [[NSDate alloc] init];
    
    int time = [now timeIntervalSinceDate:self.createdAt];
    if (time > 86400) {
        return [NSString stringWithFormat:@"%id", (time / 86400)];
    } else if (time > 3600) {
        return [NSString stringWithFormat:@"%ih", (time / 3600)];
    } else {
        return [NSString stringWithFormat:@"%im", (time / 60)];
    }
}

- (NSString *)formattedDate {
    return [NSDateFormatter localizedStringFromDate:self.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
}

- (void)toggleRetweet {
    if (self.retweeted) {
        self.retweetCount -= 1;
        [[TwitterClient sharedInstance] unretweetTweet:self];
    } else {
        self.retweetCount += 1;
        [[TwitterClient sharedInstance] retweetTweet:self];
    }
    self.retweeted = !self.retweeted;
}

- (void)toggleFavorite {
    if (self.favorited) {
        self.favoriteCount -= 1;
        [[TwitterClient sharedInstance] unfavoriteTweet:self];
    } else {
        self.favoriteCount += 1;
        [[TwitterClient sharedInstance] favoriteTweet:self];
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

    tweet.tweetId = dictionary[@"id_str"];
    
    if ([dictionary valueForKey:@"retweeted_status"]) {
        tweet.retweetId = dictionary[@"retweeted_status"][@"id_str"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
    tweet.createdAt = date;
    
    return tweet;
}

+ (Tweet *)dummyTweet:(NSString *)content withUser:(User *)user {
    Tweet *fakeTweet = [[Tweet alloc] init];

    fakeTweet.user = user;
    fakeTweet.tweetText = content;
    fakeTweet.createdAt = [[NSDate alloc] init];
    fakeTweet.favorited = NO;
    fakeTweet.retweeted = NO;
    
    return fakeTweet;
}

@end
