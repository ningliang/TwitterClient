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
      @"profile_image_url": self.profileImageUrl
    };    
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
    
    return user;
}

@end
