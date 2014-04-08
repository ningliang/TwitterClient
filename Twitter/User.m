//
//  User.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "User.h"

static User *_currentUser;

@implementation User

- (NSDictionary *)dictionaryValue {
    return @{
      @"id": @(self.userId),
      @"screen_name": self.userName,
      @"name": self.fullName,
      @"profile_image_url": self.profileImageUrl,
      @"profile_image_large_url": self.profileImageLargeUrl
    };    
}

- (NSString *)prettyTweetCount {
    return [self prettyCount:self.tweetCount];
}

- (NSString *)prettyFollowingCount {
    return [self prettyCount:self.followingCount];
}

- (NSString *)prettyFollowersCount {
    return [self prettyCount:self.followersCount];
}

- (NSString *)prettyCount:(NSInteger)count {
    if (count > 1000000) {
        return [NSString stringWithFormat:@"%.1fM", (float)count / 1000000];
    } else if (count > 1000) {
        return [NSString stringWithFormat:@"%.1fK", (float)count / 1000];
    } else {
        return [NSString stringWithFormat:@"%i", count];
    }
}

+ (void)setCurrentUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[user dictionaryValue] forKey:@"current_user"];
    [defaults synchronize];
    _currentUser = user;
}

+ (User *)currentUser {
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [defaults dictionaryForKey:@"current_user"];
        
        if (dictionary) {
            _currentUser = [User userWithDictionary:dictionary];
        }
    });
    return _currentUser;
}

+ (User *)userWithDictionary:(NSDictionary *)dictionary {
    User *user = [[User alloc] init];
    
    user.userId = [dictionary[@"id"] integerValue];
    user.userName = dictionary[@"screen_name"];
    user.fullName = dictionary[@"name"];
    user.profileImageUrl = dictionary[@"profile_image_url"];
    user.profileImageLargeUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    user.coverImageUrl = dictionary[@"profile_background_image_url"];
    
    user.location = dictionary[@"location"];
    user.websiteUrl = dictionary[@"url"];
    user.userDescription = dictionary[@"description"];

    user.tweetCount = [dictionary[@"statuses_count"] intValue];
    user.followersCount = [dictionary[@"followers_count"] intValue];
    user.followingCount = [dictionary[@"friends_count"] intValue];
    
    NSLog(@"%@", dictionary);
    
    return user;
}

@end
