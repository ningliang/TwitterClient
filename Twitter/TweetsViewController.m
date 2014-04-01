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
    self.navigationItem.title = @"Tweets";
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
    }];
}

- (void)onSignoutClick {
    [[TwitterClient sharedInstance] logout];
}

- (void)onNewTweetClick {
    // TODO load the compose view
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

- (void)didReply:(Tweet *)tweet {
    
}


@end
