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

- (NSDictionary *)dictionaryValue;

+ (void)setCurrentUser:(User *)user;
+ (User *)currentUser;
+ (User *)userWithDictionary:(NSDictionary *)dictionary;

@end
