//
//  User.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileImageLargeUrl;

@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;

- (NSDictionary *)dictionaryValue;

- (NSString *)prettyTweetCount;
- (NSString *)prettyFollowingCount;
- (NSString *)prettyFollowersCount;

+ (void)setCurrentUser:(User *)user;
+ (User *)currentUser;
+ (User *)userWithDictionary:(NSDictionary *)dictionary;

@end
