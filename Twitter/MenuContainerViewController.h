//
//  MenuContainerViewController.h
//  Twitter
//
//  Created by Ning Liang on 4/7/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"
#import "MenuViewController.h"

typedef enum {
    TimelineTypeHome,
    TimelineTypeMentions
} TimelineType;

@interface MenuContainerViewController : UIViewController <MenuDelegate, TweetListDelegate>

@property (nonatomic, assign) TimelineType timelineType;

@end
