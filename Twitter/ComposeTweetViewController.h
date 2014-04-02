//
//  ComposeTweetViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "TwitterClient.h"

@protocol ComposeTweetDelegate <NSObject>

- (void)didSaveTweet:(NSString *)content withInReplyToId:(NSString *)inReplyToIdOrNil;
- (void)didCancelTweet;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id<ComposeTweetDelegate> delegate;
@property (nonatomic, strong) NSString *initialContent;
@property (nonatomic, strong) NSString *inReplyToId;

@end
