//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)onRetweetClick;
- (void)onReplyClick;
- (void)onFavoriteClick;

@end

@implementation TweetDetailViewController

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

    // Nav bar
    self.navigationItem.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyClick)];
    
    [self.retweetButton addTarget:self action:@selector(onRetweetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton addTarget:self action:@selector(onFavoriteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.replyButton addTarget:self action:@selector(onReplyClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReplyClick {
    NSString *content = [NSString stringWithFormat:@"@%@ ", self.tweet.user.userName];
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    composeTweetViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    
    // setup compose view
    composeTweetViewController.initialContent = content;
    composeTweetViewController.inReplyToId = self.tweet.tweetId;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)onRetweetClick {
    [self.tweet toggleRetweet];
    [self refresh];
}

- (void)onFavoriteClick {
    [self.tweet toggleFavorite];
    [self refresh];
}

- (void)didSaveTweet:(NSString *)content withInReplyToId:(NSString *)replyToIdOrNil{
    [self.delegate didSaveTweet:content withInReplyToId:replyToIdOrNil];
}

- (void)didCancelTweet {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {

    self.tweetLabel.text = self.tweet.tweetText;
    self.fullNameLabel.text = self.tweet.user.fullName;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.userName];
    self.timestampLabel.text = [self.tweet formattedDate];
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    
    UIImage *favoriteImage;
    if (self.tweet.favorited) {
        favoriteImage = [UIImage imageNamed:@"favorite_on.png"];
    } else {
        favoriteImage = [UIImage imageNamed:@"favorite.png"];
    }
    [self.favoriteButton setImage:favoriteImage forState:UIControlStateNormal];
    
    UIImage *retweetedImage;
    if (self.tweet.retweeted) {
        retweetedImage = [UIImage imageNamed:@"retweet_on.png"];
    } else {
        retweetedImage = [UIImage imageNamed:@"retweet.png"];
    }
    [self.retweetButton setImage:retweetedImage forState:UIControlStateNormal];
}

@end
