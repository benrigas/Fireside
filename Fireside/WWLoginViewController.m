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
    FiresideSession* session = [FiresideSession savedSession];
    LaunchPadAuthorization* launchpadAuth = nil;
    OAuthAuthorization* oAuth = nil;
    
    if (session) {
        launchpadAuth = [session launchPadAuthorization];
        oAuth = [session oAuthAuthorization];
        [[LaunchPadAPIClient sharedInstance] setDefaultHeader:@"Authorization"
                                                        value:[NSString stringWithFormat:@"BEARER %@", oAuth.accessToken]];
    }

    // if the access token expires in less than SOME_TIME, refresh
    
    // refresh token flow
//    [LaunchPadAuthenticationAPI requestTokenWithRefreshToken:oAuth.refreshToken success:^(OAuthAuthorization *authorization) {
//        [session setOAuthAuthorization:authorization];
//        authorization.refreshToken = oAuth.refreshToken; // hang on to the refresh token for later
//        [session saveSession];
//
//        [[LaunchPadAPIClient sharedInstance] setDefaultHeader:@"Authorization"
//                                                        value:[NSString stringWithFormat:@"BEARER %@", authorization.accessToken]];
//
//    } failure:^(NSError *error) {
//        NSLog(@"error with refresh token");
//    }];
    
    if (launchpadAuth) {
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
            FiresideSession* session = [FiresideSession savedSession];
            
            if (session == nil) {
                session = [[FiresideSession alloc] init];
            }
            
            session.oAuthAuthorization = authorization;
            
            [[LaunchPadAPIClient sharedInstance] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"BEARER %@", authorization.accessToken]];

            [LaunchPadAuthenticationAPI requestAuthorizationSuccess:^(LaunchPadAuthorization *authorization) {
                session.launchPadAuthorization = authorization;
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [session saveSession];
                
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
