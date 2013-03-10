//
//  WWLoginViewController.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth2WebViewController.h"

@interface WWLoginViewController : UIViewController <OAuth2WebViewControllerDelegate>

- (IBAction)tappedLoginButton:(id)sender;

@end
