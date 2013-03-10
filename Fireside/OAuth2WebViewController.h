//
//  OAuth2WebViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OAuth2WebViewControllerDelegate;

@interface OAuth2WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL* authenticationURL;
@property (nonatomic, strong) NSURL* tokenURL;
@property (nonatomic, weak) id<OAuth2WebViewControllerDelegate> delegate;

- (void) loadAuthenticationURL;

@end

@protocol OAuth2WebViewControllerDelegate <NSObject>

- (void) oauth2WebViewController:(OAuth2WebViewController*)webAuth didFinishWithVerificationCode:(NSString*)verificationCode;

@end
