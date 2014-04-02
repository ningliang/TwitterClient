//
//  TweetsViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "TweetsViewController.h"

@interface TweetsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) TweetCell *prototypeCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL loadingMore;

@end

@implementation TweetsViewController

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
    self.navigationItem.title = @"Home";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignoutClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweetClick)];
    
    // Table view setup
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    NSAttributedString *refreshTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl.attributedTitle = refreshTitle;
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    // Infinite scroll variable
    self.loadingMore = NO;
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData {
    
    // Begin pull to refresh
    NSAttributedString *refreshMessage = [[NSAttributedString alloc] initWithString:@"Fetching Tweets"];
    [self.refreshControl setAttributedTitle:refreshMessage];

    [[TwitterClient sharedInstance] getHomeTimeline:^(NSMutableArray *tweets) {
        // End pull to refresh
        [self.refreshControl endRefreshing];
        NSAttributedString *refreshTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        [self.refreshControl setAttributedTitle:refreshTitle];

        // Reload cells
        self.tweets = tweets;
        [self.tableView reloadData];
    } withMaxId:nil];
}

- (void)onSignoutClick {
    [[TwitterClient sharedInstance] logout];
    self.tweets = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    tweetCell.tweet = self.tweets[indexPath.row];
    tweetCell.delegate = self;
    return tweetCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.tweet = self.tweets[indexPath.row];
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
 
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (void)didRetweet:(id)sender {
    TweetCell *cell = sender;
    Tweet *tweet = cell.tweet;
    [tweet toggleRetweet];
    [cell refresh];
}

- (void)didFavorite:(id)sender {
    TweetCell *cell = sender;
    Tweet *tweet = cell.tweet;
    [tweet toggleFavorite];
    [cell refresh];
}

- (void)didReply:(id)sender {
    TweetCell *cell = sender;
    Tweet *tweet = cell.tweet;
    NSString *content = [NSString stringWithFormat:@"@%@ ", tweet.user.userName];
    [self openComposeView:content withReplyToId:tweet.tweetId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] init];
    tweetDetailViewController.tweet = tweet;
    tweetDetailViewController.delegate = self;
    [self.navigationController pushViewController:tweetDetailViewController animated:YES];
}

- (void)onNewTweetClick {
    [self openComposeView:nil withReplyToId:nil];
}

- (void)openComposeView:(NSString *)contentOrNil withReplyToId:(NSString *)replyToIdOrNil {
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    composeTweetViewController.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0]];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    
    composeTweetViewController.initialContent = contentOrNil;
    composeTweetViewController.inReplyToId = replyToIdOrNil;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didSaveTweet:(NSString *)content withInReplyToId:(NSString *)inReplyToIdOrNil {
    [self.navigationController popViewControllerAnimated:YES];
    [[TwitterClient sharedInstance] tweet:content withReplyToId:inReplyToIdOrNil];

    Tweet *dummyTweet = [Tweet dummyTweet:content withUser:[User currentUser]];
    [self.tweets replaceObjectsInRange:NSMakeRange(0, 0) withObjectsFromArray:@[dummyTweet]];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didCancelTweet {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        // Not thread safe, but only one thread (UIThread) accessing this for now
        if (!self.loadingMore) {
            self.loadingMore = YES;
            Tweet *lastTweet = [self.tweets lastObject];
            NSInteger maxId = [lastTweet.tweetId integerValue] - 1;
            NSString *maxIdParam = [@(maxId) stringValue];
            
            [[TwitterClient sharedInstance] getHomeTimeline:^(NSMutableArray *tweets) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
                self.loadingMore = NO;
            } withMaxId:maxIdParam];
        }
    }
}

@end
