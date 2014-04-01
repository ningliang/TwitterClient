//
//  TweetCell.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
    self.userImageView.layer.cornerRadius = 8.0;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.userImageView.layer.borderWidth = 1.0;
    
    // Bind buttons
    [self.replyButton addTarget:self action:@selector(onReply) forControlEvents:UIControlEventTouchUpInside];
    [self.retweetButton addTarget:self action:@selector(onRetweet) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteButton addTarget:self action:@selector(onFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *replyImage = [UIImage imageNamed:@"reply.png"];
    [self.replyButton setImage:replyImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self refresh];
}

- (void)refresh {
    self.tweetLabel.text = self.tweet.tweetText;
    self.fullNameLabel.text = self.tweet.user.fullName;
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.userName];
    self.ageLabel.text = [self.tweet formattedAge];
    
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

- (void)onReply {
    [self.delegate didReply:self];
}

- (void)onRetweet {
    [self.delegate didRetweet:self];
}

- (void)onFavorite {
    [self.delegate didFavorite:self];
}

@end
