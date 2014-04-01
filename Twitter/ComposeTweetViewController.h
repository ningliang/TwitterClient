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

- (void)didSaveTweet:(NSString *)content;
- (void)didCancelTweet;

@end

@interface ComposeTweetViewController : UIViewController

@property (nonatomic, assign) id<ComposeTweetDelegate> delegate;

@end
