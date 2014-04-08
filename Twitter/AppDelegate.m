//
//  AppDelegate.m
//  Twitter
//
//  Created by Ning Liang on 3/31/14.
//  Copyright (c) 2014 Ning Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation NSURL (dictionaryFromQueryString)
-(NSDictionary *) dictionaryFromQueryString{
    
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:@"userDidLogIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootViewController) name:@"userDidLogOut" object:nil];
    
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1.0];
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    self.loginViewNavController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.loginViewNavController.navigationBar setBarTintColor:twitterBlue];
    [self.loginViewNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.loginViewNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.menuContainerViewController = [[MenuContainerViewController alloc] init];
    
    [self updateRootViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)updateRootViewController {
    User *user = [User currentUser];
    if (user) {
        self.window.rootViewController = self.menuContainerViewController;
    } else {
        self.window.rootViewController = self.loginViewNavController;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Handle the return from Twitter
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"twitterclient"]) {
        if ([url.host isEqualToString:@"request"]) {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *twitterClient = [TwitterClient sharedInstance];
                [twitterClient finishAuthorization:url.query];
            }
        }
        return YES;
    }
    return NO;
}

@end
