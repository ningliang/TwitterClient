//
//  ProfileViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/8/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *tweetsView;

@property (strong, nonatomic) TweetsViewController *tweetsViewController;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserId:(NSInteger)userId {
    self = [super initWithNibName:@"ProfileViewController" bundle:nil];
    if (self) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweetClick)];
    
    [[TwitterClient sharedInstance] getUser:self.userId success:^(User *user) {
        [self refresh:user];
    }];
    
    self.tweetsViewController = [[TweetsViewController alloc] init];
    self.tweetsViewController.allowProfileVisit = NO;
    self.tweetsViewController.delegate = self;
    [self addChildViewController:self.tweetsViewController];
    [self.tweetsView addSubview:self.tweetsViewController.view];
    
    // TODO set the header view correctly
}

- (void)refresh:(User *)user {
    self.tweetCountLabel.text = [user prettyTweetCount];
    self.followersCountLabel.text = [user prettyFollowersCount];
    self.followingCountLabel.text = [user prettyFollowingCount];
}

- (void) fetchTweets:(void (^)(NSArray *tweets))block withSinceId:(NSString *)sinceIdOrNil {
    [[TwitterClient sharedInstance] getUserTimeline:block withUserId:self.userId withMaxId:sinceIdOrNil];
}

- (void)onNewTweetClick {
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    composeTweetViewController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0]];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didSaveTweet:(NSString *)content withInReplyToId:(NSString *)inReplyToIdOrNil {
    [self.navigationController popViewControllerAnimated:YES];
    [[TwitterClient sharedInstance] tweet:content withReplyToId:inReplyToIdOrNil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didCancelTweet {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
