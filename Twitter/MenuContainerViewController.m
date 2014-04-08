//
//  MenuContainerViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/7/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "MenuContainerViewController.h"
#import "MenuViewController.h"

@interface MenuContainerViewController ()

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
    
    // Default to home timeline view
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0];
    TweetsViewController *tweetsViewController = [[TweetsViewController alloc] init];
    self.tweetsViewNavController = [[UINavigationController alloc] initWithRootViewController:tweetsViewController];
    [self.tweetsViewNavController.navigationBar setBarTintColor:twitterBlue];
    [self.tweetsViewNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.tweetsViewNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.view addSubview:self.menuViewController.view];
    [self.view addSubview:self.tweetsViewNavController.view];
    [self.view bringSubviewToFront:self.tweetsViewNavController.view];
    
    // Add gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    [panGestureRecognizer addTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPan:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint point = [panRecognizer locationInView:self.view];
    CGPoint velocity = [panRecognizer velocityInView:self.view];
    
    float halfWidth = self.view.frame.size.width / 2;
    float halfHeight = self.view.frame.size.height / 2;
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPanStart = point;
        self.lastCenter = self.tweetsViewNavController.view.center;
    } else if (panRecognizer.state == UIGestureRecognizerStateChanged) {
        float deltaX = point.x - self.lastPanStart.x;
        float newX = self.lastCenter.x + deltaX;
        
        if (newX >= halfWidth && newX <= 3 * halfWidth) {
            CGPoint newPosition = CGPointMake(newX, halfHeight);
            self.tweetsViewNavController.view.center = newPosition;
        }
    } else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        float deltaX = point.x - self.lastPanStart.x;
        float newX = self.lastCenter.x + deltaX;
        CGPoint left = CGPointMake(halfWidth, halfHeight);
        CGPoint right = CGPointMake(3 * halfWidth - 40, halfHeight);
        
        CGPoint finalPosition;
        if (velocity.x > 300) {
            finalPosition = right;
        } else if (velocity.x < -300) {
            finalPosition = left;
        } else if (newX > halfWidth * 2) {
            finalPosition = right;
        } else {
            finalPosition = left;
        }
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tweetsViewNavController.view.center = finalPosition;
        } completion:nil];
    }
}

@end
