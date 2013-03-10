//
//  Authorization.m
//  Fireside
//
//  Created by Ben Rigas on 3/9/13.
//  Copyright (c) 2013 Wakkle Works. All rights reserved.
//

#import "OAuthAuthorization.h"

@implementation OAuthAuthorization

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlias:@"refresh_token" forPropertyName:@"refreshToken"];
        [self setAlias:@"access_token" forPropertyName:@"accessToken"];
        [self setAlias:@"expires_in" forPropertyName:@"expirationDate"];
        
        [self addFormatterForPropertyName:@"expirationDate" input:^id(id expiresIn) {
            return [[NSDate date] dateByAddingTimeInterval:[expiresIn doubleValue]];
        } output:nil];
    }
    return self;
}

@end
