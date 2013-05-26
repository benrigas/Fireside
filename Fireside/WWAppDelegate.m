//
//  WWAppDelegate.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "WWAppDelegate.h"
#import "WWAppearance.h"
#import "SendButton.h"
#import "CampfireMessageCell.h"
#import "ChatTextInputView.h"

@implementation WWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setAppearance];

    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    return YES;
}

- (void) setAppearance {
//    UIColor* barTintColor = UIColorFromRGB(0x3d3d3d);
    
//    [[UIToolbar appearance] setTintColor:barTintColor];
//    [[UINavigationBar appearance] setTintColor:barTintColor];
    [[UINavigationBar appearance] setBackgroundImage:[WWAppearance navigationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    
//    [[UIBarButtonItem appearance] setBackgroundImage:[WWAppearance barButtonItemBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[WWAppearance barButtonItemBackgroundImage] forState:UIControlStateNormal style:UIBarButtonItemStylePlain barMetrics:UIBarMetricsDefault];
    
    [[UIToolbar appearance] setBackgroundImage:[WWAppearance toolbarBackgroundImage] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSDictionary *navBarTextAttributes = @{
                                           UITextAttributeTextColor         :   [UIColor whiteColor],
                                           UITextAttributeFont              :   [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0],
                                           UITextAttributeTextShadowColor   :   [UIColor colorWithRed:0 green:0 blue:0 alpha:.35],
                                           UITextAttributeTextShadowOffset  :   @1
                                           };
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTextAttributes];
    
    UIFont *buttonFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14];
    [[SendButton appearance] setTitleFont:buttonFont];
    [[SendButton appearance] setBackgroundImage:[WWAppearance sendButtonBackgroundImage] forState:UIControlStateNormal];

//    UILabel* labelAppearance = [UILabel appearanceWhenContainedIn:[CampfireMessageCell class], nil];
//    [labelAppearance setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:14]];
    
    UIFont* inputFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    ChatTextInputView* chatTextInputView = [ChatTextInputView appearance];
    [chatTextInputView setFont:inputFont];
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

@end
