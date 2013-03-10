//
//  WWLoginViewController.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "WWLoginViewController.h"
#import "LaunchPadAuthenticationAPI.h"
#import "LaunchPadAPIClient.h"
#import "FiresideSession.h"
#import "CampfireAPIClient.h"

@interface WWLoginViewController ()

@end

@implementation WWLoginViewController

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
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    
    LaunchPadAuthorization* auth = [[FiresideSession sharedInstance] launchPadAuthorization];
    
    if (auth) {
        // we're already authenticated.. let's go!
        NSLog(@"IN!");
        
        // list all the campfire accounts? if there's just one then we should go to it.
        
        [self performSegueWithIdentifier:@"ShowAccountsList" sender:self];
        
    }
    else {
        // needs login
        NSLog(@"NOT IN YET!");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedLoginButton:(id)sender {
    OAuth2WebViewController* webAuth = [[OAuth2WebViewController alloc] init];
    webAuth.delegate = self;
    webAuth.authenticationURL = [LaunchPadAuthenticationAPI urlForAuthorization];
    [self presentViewController:webAuth animated:YES completion:nil];
}

- (void) oauth2WebViewController:(OAuth2WebViewController *)webAuth didFinishWithVerificationCode:(NSString *)verificationCode {
    if (verificationCode) {
        [LaunchPadAuthenticationAPI requestTokenWithVerificationCode:verificationCode success:^(OAuthAuthorization *authorization) {
            FiresideSession* session = [FiresideSession sharedInstance];
            session.oAuthAuthorization = authorization;
            
            [[LaunchPadAPIClient sharedInstance] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"BEARER %@", authorization.accessToken]];
//            [[CampfireAPIClient sharedInstance] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"BEARER %@", authorization.accessToken]];

            [LaunchPadAuthenticationAPI requestAuthorizationSuccess:^(LaunchPadAuthorization *authorization) {
                session.launchPadAuthorization = authorization;
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
            } failure:^(NSError *error) {
                
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end