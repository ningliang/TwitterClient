//
//  ComposeTweetViewController.m
//  Twitter
//
//  Created by Ning Liang on 4/1/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@interface ComposeTweetViewController ()

- (void)onSaveTweetClick;

@property (weak, nonatomic) IBOutlet UILabel *charsLeftLabel;

@end

@implementation ComposeTweetViewController

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
    self.navigationItem.title = @"Compose";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onSaveTweetClick)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelTweetClick)];
    
    User  *user = [User currentUser];
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@ ", user.userName];
    self.fullNameLabel.text = user.fullName;
    [self.userImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    if (self.initialContent) {
        self.tweetTextView.text = self.initialContent;
    }
    
    // Mark delegate
    self.tweetTextView.delegate = self;
    
    [self.tweetTextView becomeFirstResponder];
    
    [self textViewDidChange:self.tweetTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSaveTweetClick {
    NSString *content = self.tweetTextView.text;
    if (content.length > 0) {
        [self.delegate didSaveTweet:content withInReplyToId:self.inReplyToId];
    }
}

- (void)onCancelTweetClick {
    [self.delegate didCancelTweet];
}

- (void)setText:(NSString *)content {
    self.tweetTextView.text = content;
}

- (void)setInitialContent:(NSString *)content {
    _initialContent = content;
    self.tweetTextView.text = content;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return text.length <= 140;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger charsLeft = 140 - textView.text.length;
    NSString *message = [NSString stringWithFormat:@"%i left", charsLeft];
    self.charsLeftLabel.text = message;
}

@end
