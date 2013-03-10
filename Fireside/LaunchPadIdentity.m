//
//  Identity.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "LaunchPadIdentity.h"

@implementation LaunchPadIdentity

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"email_address" forPropertyName:@"emailAddress"];
        [self setAlias:@"first_name" forPropertyName:@"firstName"];
        [self setAlias:@"last_name" forPropertyName:@"lastName"];
    }
    return self;
}

@end
