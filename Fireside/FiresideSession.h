//
//  FiresideSession.h
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchPadAuthorization.h"
#import "OAuthAuthorization.h"
#import "LaunchPadAccount.h"

@interface FiresideSession : NSObject

+ (id) sharedInstance;

@property (nonatomic, strong) OAuthAuthorization* oAuthAuthorization;
@property (nonatomic, strong) LaunchPadAuthorization* launchPadAuthorization;
@property (nonatomic, strong) LaunchPadAccount* currentLaunchPadAccount;

@end
