//
//  CampfireAPIClient.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadAPIClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"

#define kBaseURL @"https://launchpad.37signals.com/"

@implementation LaunchPadAPIClient

+ (id)sharedInstance
{
    static LaunchPadAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[LaunchPadAPIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:kBaseURL]];
        __sharedInstance.parameterEncoding = AFJSONParameterEncoding;
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

@end
