//
//  MenuContainerViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/7/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "MenuContainerViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"

@interface MenuContainerViewController ()

@property (nonatomic, strong) UINavigationController *topViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) CGPoint lastPanStart;
@property (nonatomic, assign) CGPoint lastCenter;

@end

@implementation MenuContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Menu, pull top controller right to reveal
    self.menuViewController = [[MenuViewController alloc] init];
    self.menuViewController.delegate = self;
    
    // Default to home timeline view
    [self.view addSubview:self.menuViewController.view];
    
    // Add gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    [panGestureRecognizer addTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    // Default to Home timeline
    // [self didClickHome];
    [self didClickProfile];
}

- (void)didClickHome {
    self.timelineType = TimelineTypeHome;
    
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0];
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    tweetsViewController.delegate = self;
    tweetsViewController.navigationItem.title = @"Home";
    tweetsViewController.allowProfileVisit = YES;
    
    UINavigationController *tweetsViewNavController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    [tweetsViewNavController.navigationBar setBarTintColor:twitterBlue];
    [tweetsViewNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [tweetsViewNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.topViewController = tweetsViewNavController;
}

- (void)didClickProfile {
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUserId:[User currentUser].userId];
    profileViewController.navigationItem.title = @"Me";
    
    UINavigationController *profileViewNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [profileViewNavController.navigationBar setBarTintColor:twitterBlue];
    [profileViewNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [profileViewNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.topViewController = profileViewNavController;
}

- (void)didClickMentions {
    self.timelineType = TimelineTypeMentions;
    
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0];
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    tweetsViewController.delegate = self;
    tweetsViewController.navigationItem.title = @"Mentions";
    tweetsViewController.allowProfileVisit = YES;
    
    UINavigationController *tweetsViewNavController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    [tweetsViewNavController.navigationBar setBarTintColor:twitterBlue];
    [tweetsViewNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [tweetsViewNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.topViewController = tweetsViewNavController;
}

- (void)didClickSignOut {
    [[TwitterClient sharedInstance] logout];
}

- (void)setTopViewController:(UINavigationController *)topViewController {
    if (_topViewController) {
        [_topViewController willMoveToParentViewController:nil];
        [_topViewController.view removeFromSuperview];
        [_topViewController removeFromParentViewController];
        topViewController.view.center = _topViewController.view.center;
    }
    _topViewController = topViewController;
    [self addChildViewController:_topViewController];
    [self.view addSubview:_topViewController.view];
    [self.view bringSubviewToFront:_topViewController.view];
    [self toggleTopController:YES];
}

- (void)onPan:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint point = [panRecognizer locationInView:self.view];
    CGPoint velocity = [panRecognizer velocityInView:self.view];
    
    float halfWidth = self.view.frame.size.width / 2;
    float halfHeight = self.view.frame.size.height / 2;
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPanStart = point;
        self.lastCenter = self.topViewController.view.center;
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        float deltaX = point.x - self.lastPanStart.x;
        float newX = self.lastCenter.x + deltaX;
        
        if (newX >= halfWidth && newX <= 3 * halfWidth) {
            CGPoint newPosition = CGPointMake(newX, halfHeight);
            self.topViewController.view.center = newPosition;
        }
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        float deltaX = point.x - self.lastPanStart.x;
        float newX = self.lastCenter.x + deltaX;
        
        if (velocity.x > 300) {
            [self toggleTopController:NO];
        } else if (velocity.x < -300) {
            [self toggleTopController:YES];
        } else if (newX > halfWidth * 2) {
            [self toggleTopController:NO];
        } else {
            [self toggleTopController:YES];
        }
    }
}

- (void)toggleTopController:(BOOL)onLeft {
    float halfWidth = self.view.frame.size.width / 2;
    float halfHeight = self.view.frame.size.height / 2;
    
    CGPoint finalPosition;
    if (onLeft) {
        finalPosition = CGPointMake(halfWidth, halfHeight);
    } else {
        finalPosition = CGPointMake(3 * halfWidth - 40, halfHeight);
    }
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.topViewController.view.center = finalPosition;
    } completion:nil];
}

- (void) fetchTweets:(void (^)(NSArray *tweets))block withSinceId:(NSString *)sinceIdOrNil {
    if (self.timelineType == TimelineTypeHome) {
        [[TwitterClient sharedInstance] getHomeTimeline:^(NSMutableArray *tweets) {
            block(tweets);
        } withMaxId:sinceIdOrNil];
    } else if (self.timelineType == TimelineTypeMentions) {
        [[TwitterClient sharedInstance] getMentionsTimeline:block withUserId:[User currentUser].userId withMaxId:sinceIdOrNil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
