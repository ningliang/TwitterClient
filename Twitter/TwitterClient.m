//
//  TwitterClient.m
//  Twitter
//
//  Created by Ning Liang on 3/31/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

@implementation TwitterClient

- (void)beginAuthorization {
    [self deauthorize];
    [self fetchRequestTokenWithPath:@"/oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"twitterclient://request"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                                NSLog(@"RequestToken: %@", requestToken.token);
                            } failure:^(NSError *error) {
                                NSLog(@"Error: %@", [error description]);
                            }];
}

- (void)finishAuthorization:(NSString *)queryString {
    [self fetchAccessTokenWithPath:@"/oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuthToken tokenWithQueryString:queryString]
                           success:^(BDBOAuthToken *accessToken) {
                               NSLog(@"AccessToken: %@", accessToken.token);
                               [self.requestSerializer saveAccessToken:accessToken];
                               
                               // Get the current user and authenticate them
                               [self GET:@"account/verify_credentials.json"
                              parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     User *user = [User userWithDictionary:responseObject];
                                     [User setCurrentUser:user];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidLogIn" object:self];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"FetchUser error: %@", [error description]);
                               }];
                               
                           } failure:^(NSError *error) {
                               NSLog(@"AccessToken error: %@", [error description]);
                           }];
}

- (void)retweetTweet:(Tweet *)tweet {
    NSString *path = [NSString stringWithFormat:@"statuses/retweet/%@.json", tweet.tweetId];
    
    [self POST:path parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dictionary = responseObject;
           tweet.retweetId = dictionary[@"id_str"];
           tweet.retweeted = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet tweet error: %@", [error description]);
    }];
}

- (void)unretweetTweet:(Tweet *)tweet {
    if (tweet.retweetId) {
        NSString *path = [NSString stringWithFormat:@"statuses/destroy/%@.json", tweet.retweetId];
        
        [self POST:path parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               tweet.retweetId = nil;
               tweet.retweeted = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Unretweet error: %@", [error description]);
        }];
    }
}

- (void)favoriteTweet:(Tweet *)tweet {
    NSDictionary *params = @{@"id": tweet.tweetId };
    
    [self POST:@"favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tweet.favorited = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Favorite failure: %@", [error description]);
    }];
}

- (void)unfavoriteTweet:(Tweet *)tweet {
    NSDictionary *params = @{@"id": tweet.tweetId };
    [self POST:@"favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tweet.favorited = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Unfavorite failure: %@", [error description]);
    }];
}

- (void)logout {
    [self deauthorize];
    [User setCurrentUser:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidLogOut" object:self];
}


- (void)getHomeTimeline:(void (^)(NSMutableArray *tweets))success {
    [self GET:@"statuses/home_timeline.json"
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSMutableArray *tweets = [[NSMutableArray alloc] init];
          for (NSDictionary *dictionary in responseObject) {
              Tweet *tweet = [Tweet tweetWithDictionary:dictionary];
              [tweets addObject:tweet];
          }
          success(tweets);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"GetTimeline error: %@", [error description]);
    }];
}

- (void)tweet:(NSString *)content {
    NSDictionary *params = @{@"status": content};
    [self POST:@"statuses/update" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Tweet error: %@", [error description]);
    }];
}

+ (TwitterClient *)sharedInstance {
    static dispatch_once_t pred;
    static TwitterClient *sharedInstance;

    NSString *key = @"FLzkKA1idvP3wN2K9rtMMahMw";
    NSString *secret = @"Q9bDv8P8gICZW5GbWTaDS2HPMfc1gSnctCggpCLviNMYArHwcA";

    // NSString *key = @"wrou647dSAp3OinHmsVKYw";
    // NSString *secret = @"Y1H5mOBxHMIDkW6KMeiJAd4G0VFTSA2GdVKq5SEdB4";
    NSURL *baseUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/"];
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] initWithBaseURL:baseUrl consumerKey:key consumerSecret:secret];
    });
    return sharedInstance;
}

@end
