//
//  OAuth2WebViewController.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "OAuth2WebViewController.h"

@interface OAuth2WebViewController () {
    UIWebView* authWebView;
    NSString* authVerificationCode;
}

@end

@implementation OAuth2WebViewController

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
    authWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    authWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:authWebView];
    
    authWebView.delegate = self;
    self.title = @"Sign in to Campfire";
    if (self.authenticationURL) {
        [self loadAuthenticationURL];
    }
}

- (void) loadAuthenticationURL {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:self.authenticationURL];
    [authWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL shouldLoad = YES;
    NSLog(@"request.url.host = %@, query = %@", request.URL.host, request.URL.query);
    // we want to intecept the request back to our server, because the server is really
    // the application, OAuth2 Y U SO GOOFY for apps
    if ([request.URL.host isEqualToString:@"wakkle.com"]) {
        shouldLoad =  NO;
        
        for (NSString *param in [request.URL.query componentsSeparatedByString:@"&"]) {
            NSArray *kvPair = [param componentsSeparatedByString:@"="];
            if ([[kvPair objectAtIndex:0] isEqualToString:@"code"]) {
                authVerificationCode = [kvPair objectAtIndex:1];
                break;
            }
            else if ([[kvPair objectAtIndex:0] isEqualToString:@"error"]) {
                break;
            }
        }
        // we're done, it's trying to redirect us.
        [self.delegate oauth2WebViewController:self didFinishWithVerificationCode:authVerificationCode];
    }
    
    return shouldLoad;
}

@end
