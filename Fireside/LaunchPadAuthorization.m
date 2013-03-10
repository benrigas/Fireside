//
//  Authorization.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadAuthorization.h"
#import "LaunchPadAccount.h"

@implementation LaunchPadAuthorization

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"expires_at" forPropertyName:@"expiresAt"];
        [self registerClass:[LaunchPadAccount class] forCollectionName:@"accounts"];
    }
    return self;
}

@end
