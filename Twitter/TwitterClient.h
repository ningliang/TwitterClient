//
//  TwitterClient.h
//  Twitter
//
//  Created by Ning Liang on 3/31/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

- (void) beginAuthorization;
- (void) finishAuthorization:(NSString *)queryString;
- (void) logout;
- (void)getUser:(NSInteger)userId success:(void (^)(User *user))success;

- (void)getHomeTimeline:(void (^)(NSMutableArray *tweets))success withMaxId:(NSString *)maxId;
- (void)getUserTimeline:(void (^)(NSMutableArray *tweets))success withUserId:(NSInteger)userId withMaxId:(NSString *)maxId;
- (void)getMentionsTimeline:(void (^)(NSMutableArray *tweets))success withUserId:(NSInteger)userId withMaxId:(NSString *)maxId;

- (void)retweetTweet:(Tweet *)tweet;
- (void)unretweetTweet:(Tweet *)tweet;
- (void)favoriteTweet:(Tweet *)tweet;
- (void)unfavoriteTweet:(Tweet *)tweet;
- (void)tweet:(NSString *)content withReplyToId:(NSString *)replyToIdOrNil;

+ (TwitterClient *)sharedInstance;

@end
